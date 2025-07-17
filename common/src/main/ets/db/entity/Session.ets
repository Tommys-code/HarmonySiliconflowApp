import { Columns, ColumnType, Entity } from "rdbstore";
import { systemDateTime } from "@kit.BasicServicesKit";
import { SessionTypeConvertor } from "./Convertor";

export const TABLE_SESSION = 'SESSION'

@Entity({ tableName: TABLE_SESSION })
export class Session {
  @Columns({
    name: 'ID',
    type: ColumnType.INTEGER,
    isPrimaryKey: true,
    autoincrement: true
  })
  id: number | null = null
  @Columns({ name: 'title', type: ColumnType.TEXT })
  title: string = ''
  @Columns({ name: 'userID', type: ColumnType.TEXT })
  userID: string = ''
  @Columns({ name: 'updateTime', type: ColumnType.INTEGER })
  updateTime: number = systemDateTime.getTime(true)
  @Columns({ name: 'sessionType', type: ColumnType.TEXT, convertor: SessionTypeConvertor })
  sessionType: SessionType = SessionType.CHAT
}

export enum SessionType {
  CHAT,
  IMAGE
}