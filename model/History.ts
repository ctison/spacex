import useSWR, { responseInterface } from 'swr'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function useHistory(): responseInterface<Event[], any> {
  return useSWR<Event[]>('')
}

export interface Event {
  id: number
  title: string
  event_date_utc: string
  flight_number: number
  details: string
  links: {
    reddit?: string
    article?: string
    wikipedia?: string
  }
}
