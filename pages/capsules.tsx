import { NextPage } from 'next'
import { makeStyles } from '@material-ui/core/styles'
import Link from 'next/link'
import { TableCell, TableRow } from '@material-ui/core'
import { Breadcrumbs, Table } from '@/components'
import { useCapsules } from '@/model/Capsule'

const useStyles = makeStyles(() => ({
  tableRow: {
    cursor: 'pointer',
  },
}))

export const Page: NextPage = () => {
  const classes = useStyles()
  const capsules = useCapsules('?filter=capsule_serial,capsule_id,status,type,original_launch')
  return (
    <>
      <Breadcrumbs links={[{ label: 'SpaceX', href: '/spacex' }, { label: 'Capsules' }]} />
      <Table
        isValidating={capsules.isValidating}
        columns={['ID', 'Serial', 'Status', 'Original Launch', 'Type']}
      >
        {capsules.data?.map((capsule) => (
          <Link key={capsule.capsule_serial} href={`/capsule/${capsule.capsule_serial}`}>
            <TableRow hover className={classes.tableRow}>
              <TableCell>{capsule.capsule_serial}</TableCell>
              <TableCell>{capsule.capsule_id}</TableCell>
              <TableCell>{capsule.type}</TableCell>
              <TableCell>{capsule.status}</TableCell>
              <TableCell>{capsule.original_launch}</TableCell>
            </TableRow>
          </Link>
        ))}
      </Table>
    </>
  )
}

export default Page
