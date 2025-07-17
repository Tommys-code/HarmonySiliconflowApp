import { PropertyConverter } from "rdbstore"
import { ImageRatio } from "../../models/ImageRatio"
import { SessionType } from "./Session"

export class ImageRatioConvertor extends PropertyConverter<ImageRatio, string> {
  convertToEntityProperty(databaseValue: string): ImageRatio {
    return ImageRatio.fromValue(databaseValue)
  }

  convertToDatabaseValue(entityProperty: ImageRatio): string {
    return entityProperty.value
  }
}

export class StringListConvertor extends PropertyConverter<string[], string> {
  convertToEntityProperty(databaseValue: string): string[] {
    return JSON.parse(databaseValue)
  }

  convertToDatabaseValue(entityProperty: string[]): string {
    return JSON.stringify(entityProperty)
  }
}

export class SessionTypeConvertor extends PropertyConverter<SessionType, string> {
  convertToEntityProperty(databaseValue: string): SessionType {
    if (databaseValue === undefined || databaseValue === null) {
      return SessionType.CHAT
    }
    return SessionType[databaseValue] as SessionType
  }

  convertToDatabaseValue(entityProperty: SessionType): string {
    return `${SessionType[entityProperty]}`
  }
}