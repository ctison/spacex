import React from 'react'
import { makeStyles } from '@material-ui/core/styles'
import {
  Divider,
  Drawer as MaterialDrawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  ListSubheader,
  SvgIcon,
  Toolbar,
} from '@material-ui/core'
import Link from 'next/link'
import { useRouter } from 'next/router'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import {
  faAtom,
  faCalendarAlt,
  faDragon,
  faPlaneArrival,
  faPlaneDeparture,
  faRocket,
  faSatellite,
  faSpaceShuttle,
  faTruckLoading,
} from '@fortawesome/free-solid-svg-icons'
import { IconDefinition } from '@fortawesome/fontawesome-common-types'

const drawerWidth = 240

const useStyles = makeStyles(() => ({
  drawerContainer: {
    overflow: 'auto',
  },
  drawer: {
    width: drawerWidth,
    flexShrink: 0,
  },
  drawerPaper: {
    width: drawerWidth,
  },
}))

interface DrawerProps {}

export const Drawer: React.FC<DrawerProps> = () => {
  const classes = useStyles()
  const router = useRouter()
  const listItems: {
    href?: string
    startsWith?: string
    icon: IconDefinition
    text: string
    divider?: boolean
  }[] = [
    { text: 'Capsules', icon: faSatellite },
    { text: 'Cores', icon: faAtom },
    { text: 'Dragons', icon: faDragon },
    { text: 'Payloads', icon: faTruckLoading },
    { text: 'Rockets', icon: faRocket },
    { text: 'Ships', icon: faSpaceShuttle },
    { text: 'Launch Pads', icon: faPlaneDeparture },
    { text: 'Landing Pads', icon: faPlaneArrival, divider: true },
    { text: 'History', icon: faCalendarAlt },
    { text: 'Launches', icon: faRocket, startsWith: 'spacex/launch' },
    { text: 'Missions', icon: faCalendarAlt },
  ]
  return (
    <MaterialDrawer
      variant='permanent'
      className={classes.drawer}
      classes={{ paper: classes.drawerPaper }}
    >
      <Toolbar />
      <div className={classes.drawerContainer}>
        <List
          disablePadding
          subheader={<ListSubheader component='div'>Components</ListSubheader>}
        >
          {listItems.map((item) => {
            if (!item.href) {
              item.href = `/${item.text.toLowerCase().replace(/ /, '-')}`
            }
            return (
              <React.Fragment key={item.text}>
                <Link href={item.href}>
                  <ListItem
                    button
                    selected={router.pathname.startsWith(
                      item.startsWith ?? item.href.replace(/s$/, '')
                    )}
                  >
                    <ListItemIcon>
                      <SvgIcon>
                        <FontAwesomeIcon icon={item.icon} />
                      </SvgIcon>
                    </ListItemIcon>
                    <ListItemText primary={item.text} />
                  </ListItem>
                </Link>
                {item.divider && <Divider />}
              </React.Fragment>
            )
          })}
        </List>
      </div>
    </MaterialDrawer>
  )
}

export default Drawer
