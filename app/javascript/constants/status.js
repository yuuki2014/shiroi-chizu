// 探索状態の初期値定義
export const STATUS = {
  STOPPED:   "stopped",   // 探索停止中(初期状態)
  RECORDING: "recording", // 地図記録中
  PAUSED:    "paused",    // 地図記録一時停止中
  ENDED:     "ended"      // 探索終了・保存処理中
}
