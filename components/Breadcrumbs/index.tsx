import React from 'react'
import { makeStyles } from '@material-ui/core/styles'
import NextLink from 'next/link'
import {
  Box,
  Breadcrumbs as MaterialBreadcrumbs,
  Divider,
  Link as MaterialLink,
} from '@material-ui/core'
import NavigateNextIcon from '@material-ui/icons/NavigateNext'

const useStyles = makeStyles((theme) => ({
  breadcrumbs: {
    marginBottom: theme.spacing(2),
  },
  link: {
    textTransform: 'capitalize',
  },
  divider: {
    marginBottom: theme.spacing(4),
  },
}))

export interface Link {
  label: string
  href?: string
}

interface BreadcrumbsProps {
  links: Link[]
}

export const Breadcrumbs: React.FC<BreadcrumbsProps> = (props) => {
  const classes = useStyles()
  return (
    <>
      <Box className={classes.breadcrumbs}>
        <MaterialBreadcrumbs separator={<NavigateNextIcon fontSize='small' />}>
          {props.links.slice(0, -1).map((link) => (
            <NextLink href={link.href ?? '#'} key={link.href} passHref>
              <MaterialLink color='inherit' className={classes.link}>
                {link.label}
              </MaterialLink>
            </NextLink>
          ))}
          <MaterialLink color='inherit' underline='none' className={classes.link}>
            <strong>{props.links[props.links.length - 1].label}</strong>
          </MaterialLink>
        </MaterialBreadcrumbs>
      </Box>
      <Divider className={classes.divider} />
    </>
  )
}

export default Breadcrumbs
