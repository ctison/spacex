import { NextPage } from 'next'
import { makeStyles } from '@material-ui/core/styles'
import { Box, Container, Typography } from '@material-ui/core'

const useStyles = makeStyles((theme) => ({
  root: {
    paddingTop: theme.spacing(4),
  },
  title: {
    marginBottom: theme.spacing(6),
  },
  paperCompanyInfo: {
    marginTop: theme.spacing(3),
  },
}))

export const Page: NextPage = () => {
  const classes = useStyles()
  return (
    <Container className={classes.root}>
      <Box className={classes.title}>
        <Typography variant='h2' align='center'>
          Frontend for SpaceX data API
        </Typography>
        <Typography variant='subtitle1' align='center'>
          <a href='https://github.com/r-spacex/SpaceX-API' target='_blank' rel='noreferrer'>
            https://github.com/r-spacex/SpaceX-API
          </a>
        </Typography>
      </Box>
    </Container>
  )
}

export default Page
