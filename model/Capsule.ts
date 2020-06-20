import useSWR, { responseInterface } from 'swr'

export function useCapsule(
  capsule_serial: string,
  query = '',
): responseInterface<Capsule, unknown> {
  return useSWR(`https://api.spacexdata.com/v3/capsules/${capsule_serial}` + query)
}

export function useCapsules(query = ''): responseInterface<Capsule[], unknown> {
  return useSWR('https://api.spacexdata.com/v3/capsules' + query)
}

export interface Capsule {
  error?: unknown
  capsule_serial: string
  capsule_id: string
  status: string
  original_launch: string
  missions: {
    name: string
  }[]
  landings: number
  type: string
  details: string
  reuse_count: number
}
