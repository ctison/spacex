import useSWR, { responseInterface } from 'swr'

export function usePayload(
  payload_id: string,
  query = ''
): responseInterface<Payload, unknown> {
  return useSWR(`https://api.spacexdata.com/v3/payloads/${payload_id}` + query)
}

export function usePayloads(query = ''): responseInterface<Payload[], unknown> {
  return useSWR('https://api.spacexdata.com/v3/payloads' + query)
}

export interface Payload {
  payload_id: string
  norad_id: number[]
  reused: boolean
  customers: string[]
  nationality: string
  manufacturer: string
  payload_type: string
  payload_mass_kg: number
  payload_mass_lbs: number
  orbit: string
  orbit_params: {
    reference_system: string
    regime: string
    longitude: number
    semi_major_axis_km: number
    eccentricity: number
    periapsis_km: number
    apoapsis_km: number
    inclination_deg: number
    period_min: number
    lifespan_years: number
  }
}
