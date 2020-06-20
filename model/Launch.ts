import { Core } from './Core'
import { Payload } from './Payload'

export interface Launch {
  flight_number: number
  mission_name: string
  mission_id: string[]
  launch_year: string
  launch_date_utc: string
  launch_date_local: string
  is_tentative: boolean
  tentative_max_precision: string
  tbd: boolean
  launch_window: number
  rocket: {
    rocket_id: string
    rocket_name: string
    rocket_type: string
    first_stage: {
      cores: Core[]
    }
    second_stage: {
      block: number
      payloads: Payload[]
    }
    fairings: {
      reused: boolean
      recovery_attempt: boolean
      recovered: boolean
      ship: null
    }
  }
  ships: string[]
  telemetry: {
    flight_club: string
  }
  launch_site: {
    site_id: string
    site_name: string
    site_name_long: string
  }
  launch_success: boolean
  links: {
    mission_patch: string
    mission_patch_small: string
    reddit_campaign: string
    reddit_launch: string
    reddit_recovery: null
    reddit_media: string
    presskit: string
    article_link: string
    wikipedia: string
    video_link: string
    youtube_id: string
    flickr_images: string[]
  }
  details: string
  upcoming: boolean
  static_fire_date_utc: string
  timeline: {
    webcast_liftoff: number
    go_for_prop_loading: number
    rp1_loading: number
    stage1_lox_loading: number
    stage2_lox_loading: number
    engine_chill: number
    prelaunch_checks: number
    propellant_pressurization: number
    go_for_launch: number
    ignition: number
    liftoff: number
    maxq: number
    meco: number
    stage_sep: number
    second_stage_ignition: number
    fairing_deploy: number
    first_stage_entry_burn: number
    'seco-1': number
    first_stage_landing: number
    second_stage_restart: number
    'seco-2': number
    payload_deploy: number
  }
}
