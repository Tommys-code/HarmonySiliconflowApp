export interface ChatResponseModel {
  id: string
  choices: ChoiceModel[]
}

export interface ChoiceModel {
  finish_reason?: string
  delta: DeltaModel
}

export interface DeltaModel {
  content?: string
  reasoning_content?: string
  role?: string
}

export interface ChatRequest {
  model: string
  messages: MessageModel[]
  stream: boolean
  max_tokens: number
}

export interface MessageModel {
  role: string
  content: string
}