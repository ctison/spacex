import useSWR, { responseInterface } from 'swr'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export default function useMissions(
  query = ''
): responseInterface<Mission[], any> {
  return useSWR<Mission[]>('' + query)
}

export interface Mission {
  mission_name: string
  mission_id: string
  manufacturers: string[]
  payload_ids: string[]
  wikipedia: string
  website: string
  twitter: string
  description: string
}
