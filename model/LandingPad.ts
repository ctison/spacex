import useSWR, { responseInterface } from 'swr'

export function useLandingPad(id: string, query = ''): responseInterface<LandingPad, unknown> {
  return useSWR(`https://api.spacexdata.com/v3/landpads/${id}` + query)
}

export function useLandingPads(query = ''): responseInterface<LandingPad[], unknown> {
  return useSWR('https://api.spacexdata.com/v3/landpads' + query)
}

export interface LandingPad {
  id: string
  full_name: string
  status: string
  location: {
    name: string
    region: string
    latitude: number
    longitude: number
  }
  landing_type: string
  attempted_landings: number
  successful_landings: number
}
