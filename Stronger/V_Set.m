//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "V_Set.h"
#import "M_Set.h"
// sync stuff
#import "AppDelegate.h"

@implementation V_Set
{
    CBLDatabase *database;
    M_Set *selectedSet;
    M_Set *setForRow;
}

@synthesize delegate, dataSource, tableView, isEditing,  m_ExercisePassedIn, m_ExerciseDocId, weightViewArray, repsViewArray;


#pragma mark - View lifecycle

- (void)viewDidLoadWithDatabase {
    LogFunc;

    if (!database) database = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).database;

    if (_viewDidLoad && database) {
        // Create a query sorted by descending date, i.e. newest items first:
        CBLLiveQuery *query = [[[database viewNamed:@"sets"] query] asLiveQuery];

        query.descending = YES;
        query.prefetch = YES;

        // want to only show the exercises that match the Workout we selected in V_Workouts
        query.startKey = [NSArray arrayWithObjects:m_ExerciseDocId, [NSDictionary dictionary], nil];
        query.endKey = [NSArray arrayWithObjects:m_ExerciseDocId, nil];

        self.dataSource.query = query;
    }
}

- (void)viewDidLoad {
    LogFunc;

    [super viewDidLoad];

    [CBLUITableSource class];     // Prevents class from being dead-stripped by linker

    _viewDidLoad = YES;
    isEditing = NO;
    [saveButton setTitle:@"Add Set" forState:UIControlStateNormal];
    [self populateArrays];
    
    [weightAndRepsPickerView selectRow:70 inComponent:0 animated:NO];
    [weightAndRepsPickerView selectRow:4 inComponent:1 animated:NO];
    
    [self viewDidLoadWithDatabase];
}

- (void)dealloc {
    LogFunc;

    self.weightViewArray = nil;
    self.repsViewArray = nil;
    self.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    LogFunc;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogFunc;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    LogFunc;
    
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    if(indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    LogFunc;
    
    [super viewDidDisappear:animated];
}

- (void)showErrorAlert:(NSString *)message forError:(NSError *)error {
    LogFunc;

    LogErr(@"%@: error=%@", message, error);
    [(AppDelegate *)[[UIApplication sharedApplication] delegate]
 showAlert: message error : error fatal : NO];
}

#pragma mark - CBLUITableSource delegate

//// very basic customization of the appearance of table view cells
//- (void)couchTableSource:(CBLUITableSource *)source
//             willUseCell:(UITableViewCell *)cell
//                  forRow:(CBLQueryRow *)row {
//    LogFunc;
//}

// allows delegate to return its own custom cell, just like -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source
                cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;
    
    static NSString *CellIdentifier = @"SetCell";
    
    CBLQueryRow *theRow = [source rowAtIndex:indexPath.row];
    setForRow = [M_Set modelForDocument:theRow.document];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        LogDebug(@"(cell == nil)");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *weightLabel = (UILabel *)[cell viewWithTag:100];
    weightLabel.text = [setForRow.weight stringValue];
    
    UILabel *repsLabel = (UILabel *)[cell viewWithTag:101];
    repsLabel.text = [setForRow.reps stringValue];

    LogDebug(@"%@ ✕ %@", setForRow.weight, setForRow.reps);

    return cell;
}

#pragma mark - Table view delegate

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;

    CBLQueryRow *theRow = [self.dataSource rowAtIndex:indexPath.row];
    CBLDocument *doc = theRow.document;

    selectedSet = [M_Set modelForDocument:doc];
    LogVerbose(@"selectedSet: \n%@", selectedSet);
    isEditing = YES;
    
    NSInteger weightSelectedRow = [weightViewArray indexOfObject:[selectedSet.weight stringValue]];
    NSInteger repsSelectedRow = [repsViewArray indexOfObject:[selectedSet.reps stringValue]];
    [weightAndRepsPickerView selectRow:weightSelectedRow inComponent:0 animated:YES];
    [weightAndRepsPickerView selectRow:repsSelectedRow inComponent:1 animated:YES];

    [saveButton setTitle:@"Done Editing" forState:UIControlStateNormal];
}

#pragma mark - Other TableView

- (void)couchTableSource:(CBLUITableSource *)source deleteFailed:(NSError *)error {
    LogFunc;
    
    LogErr(@"couchTableSource:(CBLUITableSource *)source deleteFailed → %@", error);
}

- (void)couchTableSource:(CBLUITableSource *)source willUpdateFromQuery:(CBLLiveQuery *)query {
    LogFunc;
    
//        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark - UIPickerView delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    LogFunc;
    NSInteger returnInt = 0;
    
    if (component == 0)
    {
        returnInt = [weightViewArray count];
    }
    if (component == 1)
    {
        returnInt = [repsViewArray count];
    }
    
	return returnInt;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    LogFunc;
    return 2;
}

#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *returnStr = @"";
	
    if (component == 0)
    {
        returnStr = [weightViewArray objectAtIndex:row];
    }
    if (component == 1)
    {
        returnStr = [repsViewArray objectAtIndex:row];
    }
	
	return returnStr;
}


# pragma mark - Actions

- (IBAction)addSetButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"Add Set\" button pressed");
    [self finishedWithSet];
}

- (void)finishedWithSet {
    LogFunc;
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *weightNumber = [format numberFromString:[weightViewArray objectAtIndex:[weightAndRepsPickerView selectedRowInComponent:0]]];
    NSNumber *repsNumber = [format numberFromString:[repsViewArray objectAtIndex:[weightAndRepsPickerView selectedRowInComponent:1]]];

    if (weightNumber == nil) {
        weightNumber = @0;
    }
    if (repsNumber == nil) {
        repsNumber = @0;
    }
    
    if (isEditing) {
        selectedSet.weight = weightNumber;
        selectedSet.reps = repsNumber;
        NSError *error;
        [selectedSet save:&error];
        
        isEditing = NO;
        [saveButton setTitle:@"Add Set" forState:UIControlStateNormal];
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        if(indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else {
    M_Set *newSet =
    [M_Set createSetWithWeight:weightNumber
                          reps:repsNumber
        belongs_to_exercise_id:m_ExercisePassedIn
                    inDatabase:database];
    
    LogVerbose(@"newSet: \n%@", newSet);
    }
    
    LogDebug(@"dataSource.rows → %i", [dataSource.rows count]);
    
//    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([dataSource.rows count] - 1) inSection:0];
//    [tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)populateArrays {
    LogFunc;
    // cat numbers | awk '{print "@[@\"" $2 "\",@" $3 "],"}' > weights
    self.weightViewArray = @[@"-350",@"-345",@"-340",@"-335",@"-330",@"-325",@"-320",@"-315",@"-310",@"-305",@"-300",@"-295",@"-290",@"-285",@"-280",@"-275",@"-270",@"-265",@"-260",@"-255",@"-250",@"-245",@"-240",@"-235",@"-230",@"-225",@"-220",@"-215",@"-210",@"-205",@"-200",@"-195",@"-190",@"-185",@"-180",@"-175",@"-170",@"-165",@"-160",@"-155",@"-150",@"-145",@"-140",@"-135",@"-130",@"-125",@"-120",@"-115",@"-110",@"-105",@"-100",@"-95",@"-90",@"-85",@"-80",@"-75",@"-70",@"-65",@"-60",@"-55",@"-50",@"-45",@"-40",@"-35",@"-30",@"-25",@"-20",@"-15",@"-10",@"-5",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",@"60",@"65",@"70",@"75",@"80",@"85",@"90",@"95",@"100",@"105",@"110",@"115",@"120",@"125",@"130",@"135",@"140",@"145",@"150",@"155",@"160",@"165",@"170",@"175",@"180",@"185",@"190",@"195",@"200",@"205",@"210",@"215",@"220",@"225",@"230",@"235",@"240",@"245",@"250",@"255",@"260",@"265",@"270",@"275",@"280",@"285",@"290",@"295",@"300",@"305",@"310",@"315",@"320",@"325",@"330",@"335",@"340",@"345",@"350",@"355",@"360",@"365",@"370",@"375",@"380",@"385",@"390",@"395",@"400",@"405",@"410",@"415",@"420",@"425",@"430",@"435",@"440",@"445",@"450",@"455",@"460",@"465",@"470",@"475",@"480",@"485",@"490",@"495",@"500",@"505",@"510",@"515",@"520",@"525",@"530",@"535",@"540",@"545",@"550",@"555",@"560",@"565",@"570",@"575",@"580",@"585",@"590",@"595",@"600",@"605",@"610",@"615",@"620",@"625",@"630",@"635",@"640",@"645",@"650",@"655",@"660",@"665",@"670",@"675",@"680",@"685",@"690",@"695",@"700",@"705",@"710",@"715",@"720",@"725",@"730",@"735",@"740",@"745",@"750",@"755",@"760",@"765",@"770",@"775",@"780",@"785",@"790",@"795",@"800",@"805",@"810",@"815",@"820",@"825",@"830",@"835",@"840",@"845",@"850",@"855",@"860",@"865",@"870",@"875",@"880",@"885",@"890",@"895",@"900",@"905",@"910",@"915",@"920",@"925",@"930",@"935",@"940",@"945",@"950",@"955",@"960",@"965",@"970",@"975",@"980",@"985",@"990",@"995",@"1000",@"1005",@"1010",@"1015",@"1020",@"1025",@"1030",@"1035",@"1040",@"1045",@"1050",@"1055",@"1060",@"1065",@"1070",@"1075",@"1080",@"1085",@"1090",@"1095",@"1100",@"1105",@"1110",@"1115",@"1120",@"1125",@"1130",@"1135",@"1140",@"1145",@"1150",@"1155",@"1160",@"1165",@"1170",@"1175",@"1180",@"1185",@"1190",@"1195",@"1200",@"1205",@"1210",@"1215",@"1220",@"1225",@"1230",@"1235",@"1240",@"1245",@"1250",@"1255",@"1260",@"1265",@"1270",@"1275",@"1280",@"1285",@"1290",@"1295",@"1300",@"1305",@"1310",@"1315",@"∞"];
    self.repsViewArray = @[@"･",@"･",@"･",@"･",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",@"100",@"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",@"110",@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118",@"119",@"120",@"121",@"122",@"123",@"124",@"125",@"126",@"127",@"128",@"129",@"130",@"131",@"132",@"133",@"134",@"135",@"136",@"137",@"138",@"139",@"140",@"141",@"142",@"143",@"144",@"145",@"146",@"147",@"148",@"149",@"150",@"151",@"152",@"153",@"154",@"155",@"156",@"157",@"158",@"159",@"160",@"161",@"162",@"163",@"164",@"165",@"166",@"167",@"168",@"169",@"170",@"171",@"172",@"173",@"174",@"175",@"176",@"177",@"178",@"179",@"180",@"181",@"182",@"183",@"184",@"185",@"186",@"187",@"188",@"189",@"190",@"191",@"192",@"193",@"194",@"195",@"196",@"197",@"198",@"199",@"200",@"201",@"202",@"203",@"204",@"205",@"206",@"207",@"208",@"209",@"210",@"211",@"212",@"213",@"214",@"215",@"216",@"217",@"218",@"219",@"220",@"221",@"222",@"223",@"224",@"225",@"226",@"227",@"228",@"229",@"230",@"231",@"232",@"233",@"234",@"235",@"236",@"237",@"238",@"239",@"240",@"241",@"242",@"243",@"244",@"245",@"246",@"247",@"248",@"249",@"250",@"251",@"252",@"253",@"254",@"255",@"256",@"257",@"258",@"259",@"260",@"261",@"262",@"263",@"264",@"265",@"266",@"267",@"268",@"269",@"270",@"271",@"272",@"273",@"274",@"275",@"276",@"277",@"278",@"279",@"280",@"281",@"282",@"283",@"284",@"285",@"286",@"287",@"288",@"289",@"290",@"291",@"292",@"293",@"294",@"295",@"296",@"297",@"298",@"299",@"300",@"301",@"302",@"303",@"304",@"305",@"306",@"307",@"308",@"309",@"310",@"311",@"312",@"313",@"314",@"315",@"316",@"317",@"318",@"319",@"320",@"321",@"322",@"323",@"324",@"325",@"326",@"327",@"328",@"329",@"330",@"331",@"332",@"333",@"334",@"335",@"336",@"337",@"338",@"339",@"340",@"341",@"342",@"343",@"344",@"345",@"∞"];
}

@end
