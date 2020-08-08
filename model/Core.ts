import useSWR, { responseInterface } from 'swr'

export function useCore(
  core_serial: string,
  query = ''
): responseInterface<Core, unknown> {
  return useSWR(`https://api.spacexdata.com/v3/cores/${core_serial}` + query)
}

export function useCores(query = ''): responseInterface<Core[], unknown> {
  return useSWR('https://api.spacexdata.com/v3/cores' + query)
}

export interface Core {
  core_serial: string
  block: number
  status: string
  original_launch: string
  missions: {
    name: string
    flight: number
  }[]
  reuse_count: number
  rtls_attempts: number
  rtls_landings: number
  asds_attempts: number
  asds_landings: number
  water_landing: boolean
  details: string
}
