# This file has been generated by
# script/constant.pl define StatusCode statuscodes

package OPCUA::Open62541::STATUSCODE;

use 5.015004;
use strict;
use warnings;
use Carp;

our $VERSION = '0.006';

BEGIN {
    my $class = 'STATUSCODE';

    # Even if we declare more than 10k constants, this is a fast way to do it.
    my $consts = <<'EOCONST';
GOOD 0
INFOTYPE_DATAVALUE 1024
INFOBITS_OVERFLOW 128
BADUNEXPECTEDERROR 2147549184
BADINTERNALERROR 2147614720
BADOUTOFMEMORY 2147680256
BADRESOURCEUNAVAILABLE 2147745792
BADCOMMUNICATIONERROR 2147811328
BADENCODINGERROR 2147876864
BADDECODINGERROR 2147942400
BADENCODINGLIMITSEXCEEDED 2148007936
BADREQUESTTOOLARGE 2159542272
BADRESPONSETOOLARGE 2159607808
BADUNKNOWNRESPONSE 2148073472
BADTIMEOUT 2148139008
BADSERVICEUNSUPPORTED 2148204544
BADSHUTDOWN 2148270080
BADSERVERNOTCONNECTED 2148335616
BADSERVERHALTED 2148401152
BADNOTHINGTODO 2148466688
BADTOOMANYOPERATIONS 2148532224
BADTOOMANYMONITOREDITEMS 2161836032
BADDATATYPEIDUNKNOWN 2148597760
BADCERTIFICATEINVALID 2148663296
BADSECURITYCHECKSFAILED 2148728832
BADCERTIFICATEPOLICYCHECKFAILED 2165571584
BADCERTIFICATETIMEINVALID 2148794368
BADCERTIFICATEISSUERTIMEINVALID 2148859904
BADCERTIFICATEHOSTNAMEINVALID 2148925440
BADCERTIFICATEURIINVALID 2148990976
BADCERTIFICATEUSENOTALLOWED 2149056512
BADCERTIFICATEISSUERUSENOTALLOWED 2149122048
BADCERTIFICATEUNTRUSTED 2149187584
BADCERTIFICATEREVOCATIONUNKNOWN 2149253120
BADCERTIFICATEISSUERREVOCATIONUNKNOWN 2149318656
BADCERTIFICATEREVOKED 2149384192
BADCERTIFICATEISSUERREVOKED 2149449728
BADCERTIFICATECHAININCOMPLETE 2165112832
BADUSERACCESSDENIED 2149515264
BADIDENTITYTOKENINVALID 2149580800
BADIDENTITYTOKENREJECTED 2149646336
BADSECURECHANNELIDINVALID 2149711872
BADINVALIDTIMESTAMP 2149777408
BADNONCEINVALID 2149842944
BADSESSIONIDINVALID 2149908480
BADSESSIONCLOSED 2149974016
BADSESSIONNOTACTIVATED 2150039552
BADSUBSCRIPTIONIDINVALID 2150105088
BADREQUESTHEADERINVALID 2150236160
BADTIMESTAMPSTORETURNINVALID 2150301696
BADREQUESTCANCELLEDBYCLIENT 2150367232
BADTOOMANYARGUMENTS 2162491392
BADLICENSEEXPIRED 2165178368
BADLICENSELIMITSEXCEEDED 2165243904
BADLICENSENOTAVAILABLE 2165309440
GOODSUBSCRIPTIONTRANSFERRED 2949120
GOODCOMPLETESASYNCHRONOUSLY 3014656
GOODOVERLOAD 3080192
GOODCLAMPED 3145728
BADNOCOMMUNICATION 2150694912
BADWAITINGFORINITIALDATA 2150760448
BADNODEIDINVALID 2150825984
BADNODEIDUNKNOWN 2150891520
BADATTRIBUTEIDINVALID 2150957056
BADINDEXRANGEINVALID 2151022592
BADINDEXRANGENODATA 2151088128
BADDATAENCODINGINVALID 2151153664
BADDATAENCODINGUNSUPPORTED 2151219200
BADNOTREADABLE 2151284736
BADNOTWRITABLE 2151350272
BADOUTOFRANGE 2151415808
BADNOTSUPPORTED 2151481344
BADNOTFOUND 2151546880
BADOBJECTDELETED 2151612416
BADNOTIMPLEMENTED 2151677952
BADMONITORINGMODEINVALID 2151743488
BADMONITOREDITEMIDINVALID 2151809024
BADMONITOREDITEMFILTERINVALID 2151874560
BADMONITOREDITEMFILTERUNSUPPORTED 2151940096
BADFILTERNOTALLOWED 2152005632
BADSTRUCTUREMISSING 2152071168
BADEVENTFILTERINVALID 2152136704
BADCONTENTFILTERINVALID 2152202240
BADFILTEROPERATORINVALID 2160132096
BADFILTEROPERATORUNSUPPORTED 2160197632
BADFILTEROPERANDCOUNTMISMATCH 2160263168
BADFILTEROPERANDINVALID 2152267776
BADFILTERELEMENTINVALID 2160328704
BADFILTERLITERALINVALID 2160394240
BADCONTINUATIONPOINTINVALID 2152333312
BADNOCONTINUATIONPOINTS 2152398848
BADREFERENCETYPEIDINVALID 2152464384
BADBROWSEDIRECTIONINVALID 2152529920
BADNODENOTINVIEW 2152595456
BADNUMERICOVERFLOW 2165440512
BADSERVERURIINVALID 2152660992
BADSERVERNAMEMISSING 2152726528
BADDISCOVERYURLMISSING 2152792064
BADSEMPAHOREFILEMISSING 2152857600
BADREQUESTTYPEINVALID 2152923136
BADSECURITYMODEREJECTED 2152988672
BADSECURITYPOLICYREJECTED 2153054208
BADTOOMANYSESSIONS 2153119744
BADUSERSIGNATUREINVALID 2153185280
BADAPPLICATIONSIGNATUREINVALID 2153250816
BADNOVALIDCERTIFICATES 2153316352
BADIDENTITYCHANGENOTSUPPORTED 2160459776
BADREQUESTCANCELLEDBYREQUEST 2153381888
BADPARENTNODEIDINVALID 2153447424
BADREFERENCENOTALLOWED 2153512960
BADNODEIDREJECTED 2153578496
BADNODEIDEXISTS 2153644032
BADNODECLASSINVALID 2153709568
BADBROWSENAMEINVALID 2153775104
BADBROWSENAMEDUPLICATED 2153840640
BADNODEATTRIBUTESINVALID 2153906176
BADTYPEDEFINITIONINVALID 2153971712
BADSOURCENODEIDINVALID 2154037248
BADTARGETNODEIDINVALID 2154102784
BADDUPLICATEREFERENCENOTALLOWED 2154168320
BADINVALIDSELFREFERENCE 2154233856
BADREFERENCELOCALONLY 2154299392
BADNODELETERIGHTS 2154364928
UNCERTAINREFERENCENOTDELETED 1086062592
BADSERVERINDEXINVALID 2154430464
BADVIEWIDUNKNOWN 2154496000
BADVIEWTIMESTAMPINVALID 2160656384
BADVIEWPARAMETERMISMATCH 2160721920
BADVIEWVERSIONINVALID 2160787456
UNCERTAINNOTALLNODESAVAILABLE 1086324736
GOODRESULTSMAYBEINCOMPLETE 12189696
BADNOTTYPEDEFINITION 2160590848
UNCERTAINREFERENCEOUTOFSERVER 1080819712
BADTOOMANYMATCHES 2154627072
BADQUERYTOOCOMPLEX 2154692608
BADNOMATCH 2154758144
BADMAXAGEINVALID 2154823680
BADSECURITYMODEINSUFFICIENT 2162556928
BADHISTORYOPERATIONINVALID 2154889216
BADHISTORYOPERATIONUNSUPPORTED 2154954752
BADINVALIDTIMESTAMPARGUMENT 2159869952
BADWRITENOTSUPPORTED 2155020288
BADTYPEMISMATCH 2155085824
BADMETHODINVALID 2155151360
BADARGUMENTSMISSING 2155216896
BADNOTEXECUTABLE 2165374976
BADTOOMANYSUBSCRIPTIONS 2155282432
BADTOOMANYPUBLISHREQUESTS 2155347968
BADNOSUBSCRIPTION 2155413504
BADSEQUENCENUMBERUNKNOWN 2155479040
BADMESSAGENOTAVAILABLE 2155544576
BADINSUFFICIENTCLIENTPROFILE 2155610112
BADSTATENOTACTIVE 2160001024
BADALREADYEXISTS 2165637120
BADTCPSERVERTOOBUSY 2155675648
BADTCPMESSAGETYPEINVALID 2155741184
BADTCPSECURECHANNELUNKNOWN 2155806720
BADTCPMESSAGETOOLARGE 2155872256
BADTCPNOTENOUGHRESOURCES 2155937792
BADTCPINTERNALERROR 2156003328
BADTCPENDPOINTURLINVALID 2156068864
BADREQUESTINTERRUPTED 2156134400
BADREQUESTTIMEOUT 2156199936
BADSECURECHANNELCLOSED 2156265472
BADSECURECHANNELTOKENUNKNOWN 2156331008
BADSEQUENCENUMBERINVALID 2156396544
BADPROTOCOLVERSIONUNSUPPORTED 2159935488
BADCONFIGURATIONERROR 2156462080
BADNOTCONNECTED 2156527616
BADDEVICEFAILURE 2156593152
BADSENSORFAILURE 2156658688
BADOUTOFSERVICE 2156724224
BADDEADBANDFILTERINVALID 2156789760
UNCERTAINNOCOMMUNICATIONLASTUSABLEVALUE 1083113472
UNCERTAINLASTUSABLEVALUE 1083179008
UNCERTAINSUBSTITUTEVALUE 1083244544
UNCERTAININITIALVALUE 1083310080
UNCERTAINSENSORNOTACCURATE 1083375616
UNCERTAINENGINEERINGUNITSEXCEEDED 1083441152
UNCERTAINSUBNORMAL 1083506688
GOODLOCALOVERRIDE 9830400
BADREFRESHINPROGRESS 2157379584
BADCONDITIONALREADYDISABLED 2157445120
BADCONDITIONALREADYENABLED 2160852992
BADCONDITIONDISABLED 2157510656
BADEVENTIDUNKNOWN 2157576192
BADEVENTNOTACKNOWLEDGEABLE 2159738880
BADDIALOGNOTACTIVE 2160918528
BADDIALOGRESPONSEINVALID 2160984064
BADCONDITIONBRANCHALREADYACKED 2161049600
BADCONDITIONBRANCHALREADYCONFIRMED 2161115136
BADCONDITIONALREADYSHELVED 2161180672
BADCONDITIONNOTSHELVED 2161246208
BADSHELVINGTIMEOUTOFRANGE 2161311744
BADNODATA 2157641728
BADBOUNDNOTFOUND 2161573888
BADBOUNDNOTSUPPORTED 2161639424
BADDATALOST 2157772800
BADDATAUNAVAILABLE 2157838336
BADENTRYEXISTS 2157903872
BADNOENTRYEXISTS 2157969408
BADTIMESTAMPNOTSUPPORTED 2158034944
GOODENTRYINSERTED 10616832
GOODENTRYREPLACED 10682368
UNCERTAINDATASUBNORMAL 1084489728
GOODNODATA 10813440
GOODMOREDATA 10878976
BADAGGREGATELISTMISMATCH 2161377280
BADAGGREGATENOTSUPPORTED 2161442816
BADAGGREGATEINVALIDINPUTS 2161508352
BADAGGREGATECONFIGURATIONREJECTED 2161770496
GOODDATAIGNORED 14221312
BADREQUESTNOTALLOWED 2162425856
BADREQUESTNOTCOMPLETE 2165506048
GOODEDITED 14417920
GOODPOSTACTIONFAILED 14483456
UNCERTAINDOMINANTVALUECHANGED 1088290816
GOODDEPENDENTVALUECHANGED 14680064
BADDOMINANTVALUECHANGED 2162229248
UNCERTAINDEPENDENTVALUECHANGED 1088552960
BADDEPENDENTVALUECHANGED 2162360320
GOODCOMMUNICATIONEVENT 10944512
GOODSHUTDOWNEVENT 11010048
GOODCALLAGAIN 11075584
GOODNONCRITICALTIMEOUT 11141120
BADINVALIDARGUMENT 2158690304
BADCONNECTIONREJECTED 2158755840
BADDISCONNECT 2158821376
BADCONNECTIONCLOSED 2158886912
BADINVALIDSTATE 2158952448
BADENDOFSTREAM 2159017984
BADNODATAAVAILABLE 2159083520
BADWAITINGFORRESPONSE 2159149056
BADOPERATIONABANDONED 2159214592
BADEXPECTEDSTREAMTOBLOCK 2159280128
BADWOULDBLOCK 2159345664
BADSYNTAXERROR 2159411200
BADMAXCONNECTIONSREACHED 2159476736
EOCONST

    open(my $fh, '<', \$consts) or croak "open consts: $!";

    local $_;
    my (%hash, $str, $num);
    while (<$fh>) {
	chomp;
	($str, $num) = split;
	$hash{"${class}_${str}"} = $num;
    }

    close($fh) or croak "close consts: $!";

    require Exporter;
    @OPCUA::Open62541::ISA = qw(Exporter);
    @OPCUA::Open62541::EXPORT_OK = keys %hash;
    %OPCUA::Open62541::EXPORT_TAGS = (all => [keys %hash]);
    sub import {
	OPCUA::Open62541->export_to_level(1, @_);
    }
}

1;

__END__

=head1 NAME

OPCUA::Open62541::STATUSCODE - define STATUSCODE from statuscodes.h

=head1 SYNOPSIS

  use OPCUA::Open62541::STATUSCODE;

  use OPCUA::Open62541::STATUSCODE qw(STATUSCODE_GOOD ...);

  use OPCUA::Open62541::STATUSCODE ':all';

=head1 DESCRIPTION

This module provides all STATUSCODE defines as Perl constants.
They have been extracted from the statuscodes.h C source file.

=head2 EXPORT

=over 4

=item STATUSCODE_GOOD

=item ...

=item STATUSCODE_BADMAXCONNECTIONSREACHED

Export specific STATUSCODE constants into the OPCUA::Open64541 name
space.

=item :all

Exports all STATUSCODE constants into the OPCUA::Open64541 name space.
You might want to import only the ones you need.

=back

=head1 SEE ALSO

OPCUA::Open62541

=head1 AUTHORS

Alexander Bluhm,
Arne Becker

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020 Alexander Bluhm
Copyright (c) 2020 Arne Becker

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Thanks to genua GmbH, https://www.genua.de/ for sponsoring this work.

=cut
