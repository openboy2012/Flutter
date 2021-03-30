class BLApi {
  ///基本API地址
  static const String BL_BASE_URL = "https://h5.mobage.cn/bl2/cn_bl2_doll_machine/api/active/";
  ///TOKEN
  static const String BL_WX_TOKEN = "m5PI6y/SsFsmH5fCslcS+kU/OTH9BOASTHKr7dIT9OnTr0jtf8kSDVbJOX1JiFywdxlifmw+i7hFhx5DFj1dYxvrPriAphvI/WTvbkUshk2gbbKe5T4AIrKT5AkFbnVm";
  ///登陆API
  static const String BL_USER_LOGIN = "/player/login";
  ///绑定角色关系
  static const String BL_USER_BIND_ROLE = "player/bindingServer";
  ///登陆账号
  static const String BL_USER_LOGOUT = "/player/logout";
  ///账号下的游戏角色信息
  static const String BL_SERVER_LIST = "/player/getServerList";
  ///获取游戏角色的积分内容
  static const String BL_GET_POINT = "/playerItem/getPoint";
  ///获取娃娃接口
  static const String BL_GET_DOLL = "/playerItem/getGashapon";
  ///获取已经获得的娃娃数据接口
  static const String BL_USER_DOLL_INFO = "/playerItem/getItemInfo";
  ///兑换娃娃接口
  static const String BL_GET_CRYSTAL = "/playerItem/exchangeItem";

  ///转盘
  static const String BLZP_BASE_URL = "https://h5-bl2-https.mobage.cn/bl2dailydraw/";
  ///微信openId
  static const String BLZP_WX_OPEN_ID = "oDRfo0ZtRcduE4TUI55x6PFE_QOQ";
  ///登陆API
  static const String BLZP_USER_LOGIN = "/sys/login";
  ///账号下的角色列表
  static const String BLZP_SERVER_LIST = "/binding/getSystem";
  ///绑定角色关系
  static const String BLZP_USER_BIND_ROLE = "/binding/bindingRegion";
  ///获取用户信息
  static const String BLZP_USER_BASEINFO = "/binding/getBaseInfo";
  ///登陆账号
  static const String BLZP_USER_LOGOUT = "/sys/logout";
  ///获取游戏角色的积分内容
  static const String BLZP_GET_CHAGNE = "/draw/getChance";
  ///转盘使用
  static const String BLZP_USE_CHNAGE = "/draw/dailyDraw";

}