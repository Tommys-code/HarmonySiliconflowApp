import { BusinessError } from "@ohos.base";
import { promptAction } from "@kit.ArkUI";
import { logger } from "../utils/Logger";
import { http } from "@kit.NetworkKit";
import { JSON, util } from "@kit.ArkTS";
import { ApikeyStore } from "../../../../Index";

interface SFRequestOptions {
  baseURL?: string
}

type SFParams = Record<string, string | number | boolean>

class SiliconFlowHttp {
  baseURL: string
  private decoder: util.TextDecoder = new util.TextDecoder()

  constructor(options: SFRequestOptions) {
    this.baseURL = options.baseURL || ''
  }

  private createHttpRequestOptions(
    path: string,
    method: http.RequestMethod = http.RequestMethod.GET,
    extraData?: Object,
    header?: (arg: http.HttpRequestOptions) => void,
    readTimeout?: number,
  ): [http.HttpRequestOptions, string] {
    const options: http.HttpRequestOptions = {
      header: {
        'Content-Type': 'application/json'
      },
      method,
      expectDataType: http.HttpDataType.OBJECT,
      readTimeout: readTimeout
    }
    let fullUrl = this.baseURL + path
    if (header) {
      header(options)
    }
    const apiKey = ApikeyStore.getInstance().getApiKey()
    if (apiKey && options.header) {
      options.header['Authorization'] = `Bearer ${apiKey}`
    }

    if (method === http.RequestMethod.GET && extraData) {
      const strArr = Object.keys(extraData)
        .filter(key => (extraData as SFParams)[key] !== undefined)
        .map(key => `${key}=${(extraData as SFParams)[key]}`)
      fullUrl += `?${strArr.join('&')}`
    } else {
      options.extraData = extraData
    }
    return [options, fullUrl]
  }

  private async request<T>(
    path: string,
    method: http.RequestMethod = http.RequestMethod.GET,
    extraData?: Object,
    header?: (arg: http.HttpRequestOptions) => void,
  ) {
    const httpInstance = http.createHttp()
    let data = this.createHttpRequestOptions(path, method, extraData, header);
    let options = data[0]
    let fullUrl = data[1]

    return await httpInstance.request(fullUrl, options).then((res) => {
      if (res.responseCode == 200) {
        return Promise.resolve(res.result as T)
      } else {
        throw new Error(res.result.toString())
      }
    }).catch((err: BusinessError) => {
      logger.error(fullUrl, err.message)
      promptAction.showToast({ message: err.message || '网络错误' })
      return Promise.reject(err)
    }).finally(() => {
      httpInstance.destroy()
    })
  }

  requestStream<T>(
    path: string,
    extraData?: Object,
    progress?: (data: T) => void,
    finish?: () => void,
  ) {
    const httpInstance = http.createHttp()
    let data = this.createHttpRequestOptions(path, http.RequestMethod.POST, extraData, undefined, 0)
    let options = data[0]
    let fullUrl = data[1]
    httpInstance.on('dataReceive', (data: ArrayBuffer) => {
      const chunk = this.decoder.decodeToString(new Uint8Array(data))
      this.processChunk(chunk, () => {
        httpInstance.off('dataReceive')
        httpInstance.destroy()
        finish?.()
      }, progress)
    })
    httpInstance.requestInStream(fullUrl, options).catch((err: BusinessError) => {
      logger.error(fullUrl, err.message)
      promptAction.showToast({ message: err.message || '网络错误' })
      return Promise.reject(err)
    }).finally(() => {
      httpInstance.off('dataReceive')
      httpInstance.destroy()
    })
  }

  private processChunk<T>(
    chuck: string,
    finish: () => void,
    progress?: (data: T) => void,
  ) {
    const data = chuck.split('data:').filter(item => item.trim().length > 0)
    for (let i = 0; i < data.length; i++) {
      const line = data[i].trim()
      if (line === '[DONE]') {
        finish()
        return
      }
      if (progress) {
        try {
          progress(JSON.parse(line) as T)
        } catch (e) {
          logger.error(e)
          promptAction.showToast({ message: e.message || '网络错误' })
          finish?.()
        }
      }
    }
  }

  get<T>(url: string, data?: Object, header?: (arg: http.HttpRequestOptions) => void,): Promise<T> {
    return this.request<T>(url, http.RequestMethod.GET, data, header)
  }

  post<T>(url: string, data?: Object): Promise<T> {
    return this.request<T>(url, http.RequestMethod.POST, data)
  }

  put<T>(url: string, data?: Object): Promise<T> {
    return this.request<T>(url, http.RequestMethod.PUT, data)
  }

  delete<T>(url: string, data?: Object): Promise<T> {
    return this.request<T>(url, http.RequestMethod.DELETE, data)
  }
}

export const sfHttp = new SiliconFlowHttp({ baseURL: "https://api.siliconflow.cn/v1/" })