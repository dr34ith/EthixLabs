
class Mission {
  final String id;
  final int order;           // 1–15, used for sorting
  final String tier;         // 'Foundational' | 'Intermediate' | 'Advanced'
  final String title;
  final String category;     // 'sqli' | 'bac' | 'combo'
  final String type;         // used by RegexEngine.checkForMission()

  final String inputField;   
 
  final String scenario;         
  final String observeContent;   

  // ── Stage 2: TEST ─────────────────────────────────────────────
  final String testInstruction;  
  final String testPayloadHint;  
  final List<String> payloads;   

  // ── Stage 3: IDENTIFY ─────────────────────────────────────────
  final String identifyQuestion;
  final List<String> identifyOptions;   
  final int identifyCorrect;            
  final String identifyExplanation;     

  // ── Stage 4: ANALYZE IMPACT ───────────────────────────────────
  final String analyzeImpact;
  final String cvssScore;

  // ── Stage 5: APPLY REMEDIATION ────────────────────────────────
  final String remediationQuestion;
  final List<String> remediationOptions; 
  final int correctRemediation;          

  // ── Meta ──────────────────────────────────────────────────────
  final String flag;
  final int stars;          
  final List<String> hints;  

  const Mission({
    required this.id,
    required this.order,
    required this.tier,
    required this.title,
    required this.category,
    required this.type,
    required this.inputField,
    required this.scenario,
    required this.observeContent,
    required this.testInstruction,
    required this.testPayloadHint,
    required this.payloads,
    required this.identifyQuestion,
    required this.identifyOptions,
    required this.identifyCorrect,
    required this.identifyExplanation,
    required this.analyzeImpact,
    required this.cvssScore,
    required this.remediationQuestion,
    required this.remediationOptions,
    required this.correctRemediation,
    required this.flag,
    required this.stars,
    required this.hints,
  });

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id:                   map['id'] as String,
      order:                map['order'] as int,
      tier:                 map['tier'] as String,
      title:                map['title'] as String,
      category:             map['category'] as String,
      type:                 map['type'] as String,
      inputField:           map['inputField'] as String,
      scenario:             map['scenario'] as String,
      observeContent:       map['observeContent'] as String,
      testInstruction:      map['testInstruction'] as String,
      testPayloadHint:      map['testPayloadHint'] as String,
      payloads:             List<String>.from(map['payloads'] as List),
      identifyQuestion:     map['identifyQuestion'] as String,
      identifyOptions:      List<String>.from(map['identifyOptions'] as List),
      identifyCorrect:      map['identifyCorrect'] as int,
      identifyExplanation:  map['identifyExplanation'] as String,
      analyzeImpact:        map['analyzeImpact'] as String,
      cvssScore:            map['cvssScore'] as String,
      remediationQuestion:  map['remediationQuestion'] as String,
      remediationOptions:   List<String>.from(map['remediationOptions'] as List),
      correctRemediation:   map['correctRemediation'] as int,
      flag:                 map['flag'] as String,
      stars:                map['stars'] as int,
      hints:                List<String>.from(map['hints'] as List),
    );
  }

  Map<String, dynamic> toMap() => {
    'id':                   id,
    'order':                order,
    'tier':                 tier,
    'title':                title,
    'category':             category,
    'type':                 type,
    'inputField':           inputField,
    'scenario':             scenario,
    'observeContent':       observeContent,
    'testInstruction':      testInstruction,
    'testPayloadHint':      testPayloadHint,
    'payloads':             payloads,
    'identifyQuestion':     identifyQuestion,
    'identifyOptions':      identifyOptions,
    'identifyCorrect':      identifyCorrect,
    'identifyExplanation':  identifyExplanation,
    'analyzeImpact':        analyzeImpact,
    'cvssScore':            cvssScore,
    'remediationQuestion':  remediationQuestion,
    'remediationOptions':   remediationOptions,
    'correctRemediation':   correctRemediation,
    'flag':                 flag,
    'stars':                stars,
    'hints':                hints,
  };



  String get identifyCorrectLetter =>
      String.fromCharCode(65 + identifyCorrect);


  String get remediationCorrectLetter =>
      String.fromCharCode(65 + correctRemediation);

  bool get isPhishingMission => type == 'phishing';


  bool get isAdvanced => tier == 'Advanced';
}