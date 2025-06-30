import { DeltaModel, logger, Role, SiliconFlowService } from 'common'
import { ChatResult, Finish, Start, Progress } from '../model/ChatResult'

@ObservedV2
export class ChatRepository {
  @Trace answer: ChatResult<DeltaModel> = Finish.INSTANCE

  sendData(data: string) {
    this.answer = Start.INSTANCE
    SiliconFlowService.chat(
      [
        { role: Role.USER, content: data }
      ],
      (data) => {
        this.dataAppend(data.choices[0]?.delta)
      },
      () => {
        this.finish()
      }
    )
  }

  private dataAppend(data: DeltaModel) {
    if (this.answer instanceof Progress) {
      let prevData = this.answer.data
      let newContent = prevData.content ? data.content
        ? prevData.content + data.content
        : prevData.content
        : data.content;
      let newReasoningContent = prevData.reasoning_content ? data.reasoning_content
        ? prevData.reasoning_content + data.reasoning_content
        : prevData.reasoning_content
        : data.reasoning_content;

      let newData: DeltaModel = {
        role: data.role,
        content: newContent,
        reasoning_content: newReasoningContent,
      }
      this.answer = new Progress(newData)
    } else {
      this.answer = new Progress(data)
    }
    logger.info(this.answer.data.content ?? '')
    logger.info(this.answer.data.reasoning_content ?? '')
  }

  private finish() {
    this.answer = Finish.INSTANCE
  }
}