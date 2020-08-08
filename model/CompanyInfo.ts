import useSWR, { responseInterface } from 'swr'

export function useCompanyInfo(
  query = ''
): responseInterface<CompanyInfo, unknown> {
  return useSWR('https://api.spacexdata.com/v3/info' + query)
}

export interface CompanyInfo {
  name: string
  founder: string
  founded: number
  employees: number
  vehicles: number
  launch_sites: number
  test_sites: number
  ceo: string
  cto: string
  coo: string
  cto_propulsion: string
  valuation: number
  headquarters: {
    address: string
    city: string
    state: string
  }
  links: {
    website: string
    flickr: string
    twitter: string
    elon_twitter: string
  }
  summary: string
}
