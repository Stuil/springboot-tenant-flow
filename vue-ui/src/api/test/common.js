import request from '@/utils/request'

// 查询常规演示列表
export function listCommon(query) {
  return request({
    url: '/test/common/list',
    method: 'get',
    params: query
  })
}

// 查询常规演示详细
export function getCommon(id) {
  return request({
    url: '/test/common/' + id,
    method: 'get'
  })
}

// 新增常规演示
export function addCommon(data) {
  return request({
    url: '/test/common',
    method: 'post',
    data: data
  })
}

// 修改常规演示
export function updateCommon(data) {
  return request({
    url: '/test/common',
    method: 'put',
    data: data
  })
}

// 删除常规演示
export function delCommon(id) {
  return request({
    url: '/test/common/' + id,
    method: 'delete'
  })
}
