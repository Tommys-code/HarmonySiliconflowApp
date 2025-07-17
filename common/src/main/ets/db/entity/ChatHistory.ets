import { Columns, ColumnType, Entity } from "rdbstore"
import { systemDateTime } from "@kit.BasicServicesKit"
import { Role } from "../../models/Role"

export const TABLE_CHAT_HISTORY = 'ChatHistory'

@Entity({ tableName: TABLE_CHAT_HISTORY })
export class ChatHistory {
  @Columns({
    name: 'ID',
    type: ColumnType.INTEGER,
    isPrimaryKey: true,
    autoincrement: true
  })
  id: number | null = null
  @Columns({ name: "sessionId", type: ColumnType.INTEGER })
  sessionId: number = 0
  @Columns({ name: "sendContent", type: ColumnType.TEXT })
  sendContent: string | null = null
  @Columns({ name: "sendRole", type: ColumnType.TEXT })
  sendRole: string = Role.USER
  @Columns({ name: "receiveContent", type: ColumnType.TEXT })
  receiveContent: string | null = null
  @Columns({ name: "receiveRole", type: ColumnType.TEXT })
  receiveRole: string | null = null
  @Columns({ name: "createTime", type: ColumnType.INTEGER })
  createTime: number = systemDateTime.getTime(true)
  @Columns({ name: "thinking", type: ColumnType.TEXT })
  thinking: string | null = null
}
