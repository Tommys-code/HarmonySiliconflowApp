export interface UserInfoModel {
  code: string
  message: string
  status: boolean
  data?: UserInfo
}

export interface UserInfo {
  id: string
  name: string
  image: string
  email: string
  balance: number
  chargeBalance: number
  totalBalance: number
}