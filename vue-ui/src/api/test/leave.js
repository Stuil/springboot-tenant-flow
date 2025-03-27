import request from '@/utils/request'

// 查询OA 请假申请列表
export function listLeave(query) {
  return request({
    url: '/test/leave/list',
    method: 'get',
    params: query
  })
}

// 查询OA 请假申请详细
export function getLeave(id) {
  return request({
    url: '/test/leave/' + id,
    method: 'get'
  })
}

// 新增OA 请假申请
export function addLeave(data) {
  return request({
    url: '/test/leave',
    method: 'post',
    data: data
  })
}

// 修改OA 请假申请
export function updateLeave(data) {
  return request({
    url: '/test/leave',
    method: 'put',
    data: data
  })
}

// 删除OA 请假申请
export function delLeave(id) {
  return request({
    url: '/test/leave/' + id,
    method: 'delete'
  })
}

// 提交审批OA 请假申请
export function submit(id) {
  return request({
    url: '/test/leave/submit/' + id,
    method: 'get'
  })
}

// 办理OA 请假申请
export function handle(data, taskId, skipType, message) {
  return request({
    url: '/test/leave/handle?taskId=' + taskId + '&skipType=' + skipType + '&message=' + message,
    data: data,
    method: 'post'
  })
}
