import { NextPage } from 'next'
import { makeStyles } from '@material-ui/core/styles'
import useSWR from 'swr'
import { useRouter } from 'next/router'
import { Box, CircularProgress, TextField, Typography } from '@material-ui/core'
import { Alert, AlertTitle } from '@material-ui/lab'
import Breadcrumbs from '@/components/Breadcrumbs'

const useStyles = makeStyles(() => ({}))

interface Mission {
  name: string
  flight: number
}

interface Core {
  error: string
  block: number
  status: string
  original_launch: string
  missions: Mission[]
  reuse_count: number
  rtls_attempts: number
  rtls_landings: number
  asds_attempts: number
  asds_landings: number
  water_landing: boolean
  details: string | null
}

export const Page: NextPage = () => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const classes = useStyles()
  const router = useRouter()
  const core = useSWR<Core>(
    `https://api.spacexdata.com/v3/cores/${router.query.serial}`
  )
  let child = <></>
  if (core.isValidating) {
    child = (
      <Box
        display='flex'
        justifyContent='center'
        alignItems='center'
        minHeight='80vh'
      >
        <CircularProgress />
      </Box>
    )
  } else if (core.error || core.data?.error) {
    const error = core.error || core.data?.error
    child = (
      <Alert severity='error'>
        <AlertTitle>Error</AlertTitle>
        {error}
      </Alert>
    )
  } else if (core.data) {
    const datas: [string, string][] = [
      ['Block', `${core.data.block}`],
      ['Status', core.data.status],
      ['Original Launch', core.data.original_launch],
      ['Reuse Count', `${core.data.reuse_count}`],
      ['Rtls Attempts', `${core.data.rtls_attempts}`],
      ['Rtls Landings', `${core.data.rtls_landings}`],
      ['Asds Attempts', `${core.data.asds_attempts}`],
      ['Asds Landings', `${core.data.asds_landings}`],
      ['Water Landing', `${core.data.water_landing}`],
      ['Details', core.data.details ?? 'N/A'],
    ]
    child = (
      <Box display='flex' flexDirection='column'>
        {datas.map((data) => (
          <TextField
            key={data[0]}
            label={data[0]}
            defaultValue={data[1]}
            InputProps={{
              readOnly: true,
            }}
            variant='outlined'
            margin='normal'
            multiline
          />
        ))}
      </Box>
    )
  }
  return (
    <>
      <Breadcrumbs
        links={[
          { label: 'SpaceX', href: '/spacex' },
          { label: 'Cores', href: '/cores' },
          {
            label:
              typeof router.query.serial == 'string'
                ? router.query.serial
                : 'Core Info',
          },
        ]}
      />
      <Typography variant='h4' align='center' gutterBottom>
        Core {router.query.serial}
      </Typography>
      {child}
    </>
  )
}

export default Page
