import { NextPage } from 'next'
import { makeStyles } from '@material-ui/core/styles'
import Link from 'next/link'
import { TableCell, TableRow } from '@material-ui/core'
import { Breadcrumbs, Table } from '@/components'
import { useCores } from '@/model/Core'

const useStyles = makeStyles(() => ({
  tableRow: {
    cursor: 'pointer',
  },
}))

export const Page: NextPage = () => {
  const classes = useStyles()
  const cores = useCores()
  return (
    <>
      <Breadcrumbs links={[{ label: 'SpaceX', href: '/spacex' }, { label: 'Cores' }]} />
      <Table isValidating={cores.isValidating} columns={['ID', 'Name', 'Block', 'Original Launch']}>
        {cores.data?.map((core) => (
          <Link key={core.core_serial} href={`/core/${core.core_serial}`}>
            <TableRow hover className={classes.tableRow}>
              <TableCell>{core.core_serial}</TableCell>
              <TableCell>{core.status}</TableCell>
              <TableCell>{core.block ?? 'unknown'}</TableCell>
              <TableCell>{new Date(core.original_launch).toUTCString()}</TableCell>
            </TableRow>
          </Link>
        ))}
      </Table>
    </>
  )
}

export default Page
