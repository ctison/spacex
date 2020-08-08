import { NextPage } from 'next'
import { makeStyles } from '@material-ui/core/styles'
import { useRouter } from 'next/router'
import { Box, CircularProgress, TextField, Typography } from '@material-ui/core'
import { Alert, AlertTitle } from '@material-ui/lab'
import Breadcrumbs from '@/components/Breadcrumbs'
import { useCapsule } from '@/model/Capsule'

const useStyles = makeStyles(() => ({}))

export const Page: NextPage = () => {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const classes = useStyles()
  const router = useRouter()
  const capsuleSerial =
    typeof router.query.serial == 'string'
      ? router.query.serial
      : 'Capsule Info'
  const capsule = useCapsule(capsuleSerial)
  let child = <></>
  if (capsule.isValidating) {
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
  } else if (capsule.error || capsule.data?.error) {
    const error = capsule.error || capsule.data?.error
    child = (
      <Alert severity='error'>
        <AlertTitle>Error</AlertTitle>
        {error}
      </Alert>
    )
  } else if (capsule.data) {
    const datas: [string, string][] = [
      ['Type', capsule.data.type],
      ['Identifier', capsule.data.capsule_id],
      ['Status', capsule.data.status],
      ['Original Launch', capsule.data.original_launch],
      ['Landings', `${capsule.data.landings}`],
      ['Reuse Count', `${capsule.data.reuse_count}`],
      ['Details', capsule.data.details ?? 'N/A'],
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
          { label: 'Capsules', href: '/capsules' },
          { label: capsuleSerial },
        ]}
      />
      <Typography variant='h4' align='center' gutterBottom>
        Capsule {router.query.serial}
      </Typography>
      {child}
    </>
  )
}

export default Page
