import '../styles/globals.css'
import NodeContext from '../context/nodes/NodeContext'

function MyApp({ Component, pageProps }) {
  return <NodeContext><Component {...pageProps} /></NodeContext>
}

export default MyApp
