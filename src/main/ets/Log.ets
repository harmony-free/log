import { util } from '@kit.ArkTS'
import { sensor } from '@kit.SensorServiceKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { ComponentContent, PromptAction } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { logBuilder } from './components/LogPage'

type Type<K = object, V = object> = string | object | Map<K, V> | Array<K>

enum LogType {
  LOG = 'log',
  INFO = 'info'
}

export interface LogModelFace<T> {
  data: T
  createTime: Date
  type: LogType
}

class LogModel<T = object> implements LogModelFace<T> {
  data: T
  createTime: Date = new Date()
  type: LogType

  constructor(data: T, type: LogType = LogType.LOG) {
    this.data = data
    this.type = type
  }
}

interface LogFace {
  logList: Array<LogModelFace<string>>
  logAfter: (instance: console, ret: string, arg: string, ...args: object[]) => void
}

@ObservedV2
export class LogUtils implements LogFace {
  max: number = 100
  @Trace logList: Array<LogModelFace<string>> = new Array<LogModelFace<string>>()

  constructor() {
    util.Aspect.addAfter(console, 'log', true, this.logAfter)
    util.Aspect.addAfter(console, 'info', true, this.logAfter)
  }

  logAfter: (instance: console, method: string, arg: string, ...args: object[]) => void =
    (instance: console, method: string, arg: string, ...args: object[]) => {
      let msg = arg
      if (args != undefined) {
        args.forEach((a) => {
          if (a instanceof Map) {
            msg += JSON.stringify(this.toRecord(a))
          } else {
            msg += JSON.stringify(a)
          }
        })
      }
      if (this.logList.length > this.max) {
        this.logList.pop()
      }
      this.logList.push(new LogModel(msg))
    }

  log(data: Type) {
    if (typeof data == 'string') {
      console.log(data)
    } else if (data instanceof Map) {
      console.log(JSON.stringify(data))
    } else {
      console.log(JSON.stringify(data))
    }
  }

  /**
   * map 转化为Record类型
   * @param map
   * @returns
   */
  toRecord(map: Map<string, object>): Record<string, object> {
    let r: Record<string, object> = {}
    map.forEach((value, key) => {
      if (key !== undefined && value !== undefined) {
        r[key] = value;
      }
    })
    return r
  }
}


export class SensorUtils {
  isOn: boolean = true
  num: number = 20.0
  type:"router"|"navigation" = "navigation";
  sensors: Array<sensor.Sensor>  = []
  action: (data: sensor.GyroscopeResponse)=>void = this.openLog

  constructor() {
    this.sensors = sensor.getSensorListSync()
  }

  findSensor(id:sensor.SensorId):boolean{
    return this.sensors.find((s)=>s.sensorId == id) !== undefined;
  }

  open() {
    if (this.findSensor(sensor.SensorId.ACCELEROMETER)){
      try {
        sensor.on(sensor.SensorId.ACCELEROMETER, this.action.bind(this));
      } catch (error) {
        let e: BusinessError = error as BusinessError;
        console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
      }
    }else{
      console.error(`not find id with ${sensor.SensorId.ACCELEROMETER}`);
    }
  }

  protected promptAction(): PromptAction {
    let context = getContext() as common.UIAbilityContext
    return context.windowStage.getMainWindowSync().getUIContext().getPromptAction()
  }

  getUIContext():UIContext{
    let context = getContext() as common.UIAbilityContext
    return context.windowStage.getMainWindowSync().getUIContext()
  }

  openLog(data: sensor.GyroscopeResponse){
    if ((data.x > this.num || data.y > this.num || data.z > this.num) && (this.isOn)) {
      this.isOn = false
      this.showLog(wrapBuilder(logBuilder)).then((v)=>{
        this.isOn = true
      }).catch((e:object)=>{
        this.isOn = true
      });
    }
  }

  showLog(wrapBuilder: WrappedBuilder<[PromptParams]>,data:PromptDataType = undefined):Promise<PromptDataType>{
    return new Promise<PromptDataType>((res, rej) => {
      let context = getContext() as common.UIAbilityContext
      let promptAction = context.windowStage.getMainWindowSync().getUIContext().getPromptAction()
      let uiContext = context.windowStage.getMainWindowSync().getUIContext()
      let custom = new ComponentContent<PromptParams>(uiContext, wrapBuilder, {
        data: data,
        close: (data: PromptDataType) => {
          promptAction.closeCustomDialog(custom).then(() => {
            custom.dispose()
          })
          res(data)
        }
      })
      promptAction.openCustomDialog(custom, {
        alignment: DialogAlignment.Bottom,
        onWillDismiss: (action: DismissDialogAction) => {
          action.dismiss()
          custom.dispose()
          rej("onWillDismiss")
        },
      })
    })

  }

  close(){
    console.error(`close=========================================`);
    try {
      sensor.off(sensor.SensorId.ACCELEROMETER, this.action.bind(this));
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
  }
}

export  type PromptDataType = object | boolean | string | number | undefined

export  interface PromptParams{
  data: PromptDataType
  close:(data: PromptDataType) => void
}

export const  log: LogUtils = new LogUtils()
export const  sen: SensorUtils = new SensorUtils()

export  function openLog(num:number = 20){
  sen.num = num
  sen.open();
}

export function closeLog(){
  sen.close();
}