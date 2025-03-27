import request from '@/utils/request'

// 查询待办任务列表
export function toDoPage(query) {
  return request({
    url: '/flow/execute/toDoPage',
    method: 'get',
    params: query
  })
}

// 查询已办任务列表
export function donePage(query) {
  return request({
    url: '/flow/execute/donePage',
    method: 'get',
    params: query
  })
}

// 查询已办任务列表
export function doneList(instanceId) {
  return request({
    url: '/flow/execute/doneList/' + instanceId,
    method: 'get'
  })
}
