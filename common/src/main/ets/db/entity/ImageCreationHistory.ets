import { Columns, ColumnType, Entity } from "rdbstore"
import { ImageRatio } from "../../models/ImageRatio"
import { ImageRatioConvertor, StringListConvertor } from "./Convertor"

@Entity({ tableName: 'ImageCreationHistory' })
export class ImageCreationHistory {
  @Columns({
    name: 'ID',
    type: ColumnType.INTEGER,
    isPrimaryKey: true,
    autoincrement: true
  })
  id: number | null = null
  @Columns({ name: "sessionId", type: ColumnType.INTEGER })
  sessionId: number = 0
  @Columns({ name: "prompt", type: ColumnType.TEXT })
  prompt: string = ''
  @Columns({ name: "ratio", type: ColumnType.TEXT, convertor: ImageRatioConvertor })
  ratio: ImageRatio = ImageRatio.RATIO_1_1
  @Columns({ name: "batchSize", type: ColumnType.INTEGER })
  batchSize: number = 1
  @Columns({ name: "createTime", type: ColumnType.INTEGER })
  createTime: number = 0
  @Columns({ name: "seed", type: ColumnType.INTEGER })
  seed: number = 0
  @Columns({ name: 'images', type: ColumnType.TEXT, convertor: StringListConvertor })
  images: string[] | null = null
  @Columns({ name: 'baseImage', type: ColumnType.TEXT })
  baseImage: string | null = null
}
