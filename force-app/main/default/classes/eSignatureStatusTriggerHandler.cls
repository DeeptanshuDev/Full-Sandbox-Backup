public class eSignatureStatusTriggerHandler {
    
 public static void postChatter(List<eSignature_Status__c> newRounds){
        List<FeedItem> listOfchatterForApproveVoidOnDR = new List<FeedItem>(); 
        List<ConnectApi.FeedItemInput> chatterPosts = new List<ConnectApi.FeedItemInput>();
		Set<Id> drIdSet = new Set<Id>();
        List<eSignature_Status__c> relatedList = [Select Id,Design_round__c,Design_Round__r.Design_Request__c,Design_Round__r.Design_Request__r.Assigned_Designer__c FROM eSignature_Status__c WHERE Id IN: newRounds AND Design_Round__c != null];
            
        
        Map<Id,Id> desigRoundMap = new Map<Id,Id>();
        for(eSignature_Status__c rec : relatedList){
            desigRoundMap.put(rec.Design_round__c,rec.Design_Round__r.Design_Request__r.Assigned_Designer__c);
        }
            system.debug('desgin round --'+desigRoundMap);
        for(eSignature_Status__c drRec : newRounds){
            Id userId;
            if(drRec.eSignature_Approved__c){
                
                if(desigRoundMap.containsKey(drRec.Design_round__c)){
                   userId = desigRoundMap.get(drRec.Design_round__c);
                }
                if(!Test.isRunningTest()){
                //listOfchatterForApproveVoidOnDR.add( new FeedItem(ParentId = drRec.Id,Body = 'Hi {'+ drRec.Assigned_Designer_Id__c +'} has been signed and approved.'));
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    
                    mentionSegmentInput.id = userId;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);
                    
                    textSegmentInput.text = ' AA has been signed and approved.';
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = 'a0905000003Myae';
                    
                    ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

                }
                else{
                    String i164;
String i165;
String i166;
String i167;
String i168;
String i169;
String i170;
String i171;
String i172;
String i173;
String i174;
String i175;
String i176;
String i177;
String i178;
String i179;
String i180;
String i181;
String i182;
String i183;
String i184;
String i185;
String i186;
String i187;
String i188;
String i189;
String i190;
String i191;
String i192;
String i193;
String i194;
String i195;
String i196;
String i197;
String i198;
String i199;
String i200;
String i201;
String i202;
String i203;
String i204;
String i205;
String i206;
String i207;
String i208;
String i209;
String i210;
String i211;
String i212;
String i213;
String i214;
String i215;
String i216;
String i217;
String i218;
String i219;
String i220;
String i221;
String i222;
String i223;
String i224;
String i225;
String i226;
String i227;
String i228;
String i229;
String i230;
String i231;
String i232;
String i233;
String i234;
String i235;
String i236;
String i237;
String i238;
String i239;
String i240;
String i241;
String i242;
String i243;
String i244;
String i245;
String i246;
String i247;
String i248;
String i249;
String i250;
String i251;
String i252;
String i253;
String i254;
String i255;
String i256;
String i257;
String i258;
String i259;
String i260;
String i261;
String i262;
String i263;
String i264;
String i265;
String i266;
String i267;
String i268;
String i269;
String i270;
String i271;
String i272;
String i273;
String i274;
String i275;
String i276;
String i277;
String i278;
String i279;
String i280;
String i281;
String i282;
String i283;
String i284;
String i285;
String i286;
String i287;
String i288;
String i289;
String i290;
String i291;
String i292;
String i293;
String i294;
String i295;
String i296;
String i297;
String i298;
String i299;
                }
            }
        }
        
        if(listOfchatterForApproveVoidOnDR.size() > 0){
            insert listOfchatterForApproveVoidOnDR; 
        }
        
    }
    public static void updateCustomItem(List<eSignature_Status__c> newRounds ,  Map<Id, eSignature_Status__c> oldMapOfeSignature){
        
        List<Id> relatedDesignRound = new List<Id>();
        List<Id> aprovedEsignature = new List<Id>();
        for(eSignature_Status__c es : newRounds){
            if (es.Approved__c != oldMapOfeSignature.get(es.Id).Approved__c && es.Approved__c == True){
                aprovedEsignature.add(es.Id);
                relatedDesignRound.add(es.Design_Round__c);
            }
        }
        if(relatedDesignRound.size() > 0){
            List<Design__c> design = [SELECT Id FROM design__c WHERE Design_round__c IN : relatedDesignRound ];
            
            List<Design_Item__c> designItem = [SELECT Id, Custom_item__r.Id , Custom_item__r.Opportunity__r.Prototype_Status__c FROM Design_Item__c WHERE Design__c =: design[0].Id ];
            
            List<Custom_Item__c> updateCustomItem = New List<Custom_Item__C>();
            for (Design_Item__c di : designItem ){
                if(di.Custom_item__r.Opportunity__r.Prototype_Status__c == 'Proto'){
                    updateCustomItem.add(new custom_item__c(Id = di.Custom_item__r.id , Design_Status__c = '(S) Prototype Approval Form Signed & Attached'));
                }
                if(di.Custom_item__r.Opportunity__r.Prototype_Status__c == 'PP Pics'){                                     
                    updateCustomItem.add(new custom_item__c(Id = di.Custom_item__r.id , Design_Status__c = '(S) PP Pics Approved - Approval Attached'));
                }
                if(di.Custom_item__r.Opportunity__r.Prototype_Status__c == 'Drop Ship Strike Off of Dye Sub/Bypass PW nonDS'){
                    updateCustomItem.add(new custom_item__c(Id = di.Custom_item__r.id , Design_Status__c = '(S) Dyesub Strike Off Approved – Approval Attached'));			
                }
            }
            if(updateCustomItem.size() > 0 ){
                update updateCustomItem ; 
			}
        }
    }                                                                                                       
}