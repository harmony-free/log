import { log, LogModelFace, PromptParams } from "../Log"

@Builder
export function logBuilder(o: PromptParams) {
  LogView({o:o})
}

@Component
export struct LogView {

  o: PromptParams | undefined

  build() {
    Column() {
      Text("控制台日志").padding({bottom:10,top:10});
      List({ space: 1, initialIndex: 0 }) {
        ForEach(log.logList, (item: LogModelFace<string>) => {
          ListItem() {
            Row() {
              Text(`${item.createTime.getHours()}:${item.createTime.getMinutes()}:${item.createTime.getSeconds()} `)
              Text(item.data).maxLines(1).width('80%').textOverflow({ overflow: TextOverflow.Ellipsis })
            }.onClick(() => {
              AlertDialog.show({ message: item.data })
            }).padding(5).width('100%')
          }
        })
      }.flexGrow(1).height(400).padding({bottom:10})
    }.backgroundColor(Color.White)
  }
}
