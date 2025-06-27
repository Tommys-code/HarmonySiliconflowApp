import { BusinessError } from "@ohos.base";
import { promptAction, router } from "@kit.ArkUI";
import { logger } from "../utils/Logger";
import { settingStore } from "../datastore/SettingDataStore";
import { http } from "@kit.NetworkKit";

interface SFRequestOptions {
  baseURL?: string
}

type SFParams = Record<string, string | number | boolean>

class SiliconFlowHttp {
  baseURL: string

  constructor(options: SFRequestOptions) {
    this.baseURL = options.baseURL || ''
  }

  private async request<T>(
    path: string,
    method: http.RequestMethod = http.RequestMethod.GET,
    extraData?: Object,
    header?: (arg: http.HttpRequestOptions) => void,
  ) {
    const httpInstance = http.createHttp()

    const options: http.HttpRequestOptions = {
      header: {
        'Content-Type': 'application/json'
      },
      method,
      expectDataType: http.HttpDataType.OBJECT
    }
    let fullUrl = this.baseURL + path

    if (header) {
      header(options)
    }

    const apiKey = settingStore.getApiKey()
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