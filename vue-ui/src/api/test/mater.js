import request from '@/utils/request'

// 查询主子演示列表
export function listMater(query) {
  return request({
    url: '/test/mater/list',
    method: 'get',
    params: query
  })
}

// 查询主子演示详细
export function getMater(id) {
  return request({
    url: '/test/mater/' + id,
    method: 'get'
  })
}

// 新增主子演示
export function addMater(data) {
  return request({
    url: '/test/mater',
    method: 'post',
    data: data
  })
}

// 修改主子演示
export function updateMater(data) {
  return request({
    url: '/test/mater',
    method: 'put',
    data: data
  })
}

// 删除主子演示
export function delMater(id) {
  return request({
    url: '/test/mater/' + id,
    method: 'delete'
  })
}
