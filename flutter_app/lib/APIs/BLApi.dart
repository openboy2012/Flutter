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
  ///获取娃娃数据
  static const String BL_USER_DOLL_INFO = "/playerItem/getItemInfo";
}