//Generated by wsdl2apex

public class AsyncNeustarWsGetdata {
    public class batchQueryResponse_elementFuture extends System.WebServiceCalloutFuture {
        public NeustarWsGetdata.BatchResponseMsgType getValue() {
            NeustarWsGetdata.batchQueryResponse_element response = (NeustarWsGetdata.batchQueryResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.batchResponse;
        }
    }
    public class queryResponse_elementFuture extends System.WebServiceCalloutFuture {
        public NeustarWsGetdata.ResponseMsgType getValue() {
            NeustarWsGetdata.queryResponse_element response = (NeustarWsGetdata.queryResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.response;
        }
    }
    public class AsyncClientSoap {
        public String endpoint_x = 'http://webapp.targusinfo.com/ws-getdata/query.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://TARGUSinfo.com/WS-GetData', 'NeustarWsGetdata'};
        public AsyncNeustarWsGetdata.batchQueryResponse_elementFuture beginBatchQuery(System.Continuation continuation,NeustarWsGetdata.OriginationType origination,String serviceId,Integer transId,NeustarWsGetdata.ArrayOfInt elements,NeustarWsGetdata.ArrayOfServiceKeyType globalServiceKeys,NeustarWsGetdata.ArrayOfBatchQueryType queries) {
            NeustarWsGetdata.batchQuery_element request_x = new NeustarWsGetdata.batchQuery_element();
            request_x.origination = origination;
            request_x.serviceId = serviceId;
            request_x.transId = transId;
            request_x.elements = elements;
            request_x.globalServiceKeys = globalServiceKeys;
            request_x.queries = queries;
            return (AsyncNeustarWsGetdata.batchQueryResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncNeustarWsGetdata.batchQueryResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://TARGUSinfo.com/WS-GetData/batchQuery',
              'http://TARGUSinfo.com/WS-GetData',
              'batchQuery',
              'http://TARGUSinfo.com/WS-GetData',
              'batchQueryResponse',
              'NeustarWsGetdata.batchQueryResponse_element'}
            );
        }
        public AsyncNeustarWsGetdata.queryResponse_elementFuture beginQuery(System.Continuation continuation,NeustarWsGetdata.OriginationType origination,String serviceId,Integer transId,NeustarWsGetdata.ArrayOfInt elements,NeustarWsGetdata.ArrayOfServiceKeyType serviceKeys) {
            NeustarWsGetdata.query_element request_x = new NeustarWsGetdata.query_element();
            request_x.origination = origination;
            request_x.serviceId = serviceId;
            request_x.transId = transId;
            request_x.elements = elements;
            request_x.serviceKeys = serviceKeys;
            return (AsyncNeustarWsGetdata.queryResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncNeustarWsGetdata.queryResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://TARGUSinfo.com/WS-GetData/query',
              'http://TARGUSinfo.com/WS-GetData',
              'query',
              'http://TARGUSinfo.com/WS-GetData',
              'queryResponse',
              'NeustarWsGetdata.queryResponse_element'}
            );
        }
    }
}