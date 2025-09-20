import 'package:aswdc_flutter_pub/aswdc_flutter_pub.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/import_export.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: appColor,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreenBackground,
      body: Stack(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: appColor,
                secondary: appColor,
                surface: lightGreenBackground,
                onPrimary: colorWhite,
                onSecondary: colorWhite,
                onSurface: colorGreyShade600,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: appColor,
                foregroundColor: colorWhite,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                color: colorWhite,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              listTileTheme: ListTileThemeData(
                tileColor: colorWhite,
                textColor: colorGreyShade600,
                iconColor: appColor,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                  foregroundColor: colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: appColor,
                ),
              ),
              iconTheme: IconThemeData(
                color: appColor,
              ),
              primaryIconTheme: const IconThemeData(
                color: colorWhite,
              ),
              extensions: [
                DeveloperScreenTheme(
                  sectionHeaderColor: appColor, // Change purple to light green
                  sectionHeaderTextColor: colorWhite,
                  cardBackgroundColor: colorWhite,
                  primaryColor: appColor,
                ),
              ],
            ),
            child: DeveloperScreen(
              developerName: 'Ayushi Patel (23010101199)',
              mentorName: 'Prof. Rajkumar Gondaliya',
              exploredByName: 'ASWDC',
              isAdmissionApp: true,
              isDBUpdate: true,
              shareMessage: shareMessage,
              appTitle: 'Ecodomia',
              appTitleColor : Colors.black,
              appLogo: 'assets/images/Main Logo.jpg',
              androidAPPURL: androidAppURL,
              iosAPPURL: iOSAppURL,
              appBarColor: appColor,
              sectionHeaderColor: appColor,
              primaryColor: appColor,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: CircleAvatar(
              backgroundColor: appColor,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: colorWhite),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    const String appUrl =
        "https://play.google.com/store/apps/details?id=com.example.myapp";
    Share.share("Check out this app: $appUrl");
  }
}

class DeveloperScreenTheme extends ThemeExtension<DeveloperScreenTheme> {
  final Color sectionHeaderColor;
  final Color sectionHeaderTextColor;
  final Color cardBackgroundColor;
  final Color primaryColor;

  const DeveloperScreenTheme({
    required this.sectionHeaderColor,
    required this.sectionHeaderTextColor,
    required this.cardBackgroundColor,
    required this.primaryColor,
  });

  @override
  DeveloperScreenTheme copyWith({
    Color? sectionHeaderColor,
    Color? sectionHeaderTextColor,
    Color? cardBackgroundColor,
    Color? primaryColor,
  }) {
    return DeveloperScreenTheme(
      sectionHeaderColor: sectionHeaderColor ?? this.sectionHeaderColor,
      sectionHeaderTextColor: sectionHeaderTextColor ?? this.sectionHeaderTextColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }

  @override
  DeveloperScreenTheme lerp(ThemeExtension<DeveloperScreenTheme>? other, double t) {
    if (other is! DeveloperScreenTheme) {
      return this;
    }
    return DeveloperScreenTheme(
      sectionHeaderColor: Color.lerp(sectionHeaderColor, other.sectionHeaderColor, t)!,
      sectionHeaderTextColor: Color.lerp(sectionHeaderTextColor, other.sectionHeaderTextColor, t)!,
      cardBackgroundColor: Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t)!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
    );
  }
}

const String androidAppURL =
    "https://play.google.com/store/apps/details?id=com.example.myapp";
const String iOSAppURL = "https://apps.apple.com";
const String shareMessage = "Download Ecodomia app today!";

const Color lightGreenBackground = Color(0xFFE8F5E9);
final Color appColor = Colors.lightGreen.shade600; // ✅ Main Color Everywhere
const Color colorWhite = Colors.white;
const Color colorGreyShade600 = Colors.green;

const FontWeight medium = FontWeight.w500;
const FontWeight regular = FontWeight.w400;
const FontWeight regular500 = FontWeight.w500;


Widget containersFortheData(String value) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 0, 150, 0),
    height: 40,
    width: 150,
    decoration: BoxDecoration(
      color: appColor,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Center(
      child: Text(
        value,
        style: const TextStyle(
            color: colorWhite, fontSize: 17, fontWeight: medium),
      ),
    ),
  );
}

Widget customSectionHeader(String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: appColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: appColor.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: colorWhite,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget meetOurTeam(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4, top: 1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label :",
          style: TextStyle(color: appColor, fontWeight: medium),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 14, color: colorGreyShade600),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    ),
  );
}

Widget buildInfoCard(String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Row(
      children: [
        Icon(icon, color: appColor, size: 18),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 14, fontWeight: regular500, color: colorGreyShade600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget footerData() {
  return Center(
    child: Column(
      children: const [
        Text(
          "© 2025 Darshan University",
          style: TextStyle(
              fontWeight: regular, fontSize: 12, color: colorGreyShade600),
        ),
        Text(
          "All Rights Reserved - Privacy Policy",
          style: TextStyle(fontSize: 12, color: colorGreyShade600),
        ),
        Text(
          "Made with ❤ in India",
          style: TextStyle(fontSize: 12, color: colorGreyShade600),
        ),
      ],
    ),
  );
}

Widget contactNumber(BuildContext context, String phoneString) {
  final List<String> phoneNumbers = phoneString
      .split(',')
      .map((number) => number.trim())
      .where((number) => number.isNotEmpty)
      .toList();

  return Column(
    children: [
      Container(
        color: lightGreenBackground,
        child: ListTile(
          minTileHeight: 4.0,
          contentPadding: const EdgeInsets.only(left: 4),
          title: Row(
            children: [
              Icon(Icons.phone, color: appColor, size: 18),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  '+91-9727747317',
                  style: TextStyle(fontSize: 14, color: colorGreyShade600),
                ),
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: colorWhite,
                title: Text(
                  'Select a Number',
                  style: TextStyle(color: appColor),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: phoneNumbers.map((number) {
                    return ListTile(
                      title: Text(
                        number,
                        style: const TextStyle(color: colorGreyShade600),
                      ),
                      onTap: () async {
                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: number,
                        );
                        await launchUrl(phoneUri);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget email(BuildContext context, String emailString) {
  final List<String> emailAddresses = emailString
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  return Column(
    children: [
      Container(
        color: lightGreenBackground,
        child: ListTile(
          minTileHeight: 4.0,
          contentPadding: const EdgeInsets.only(left: 4),
          title: Row(
            children: [
              Icon(Icons.email, color: appColor, size: 18),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'aswdc@darshan.ac.in',
                  style: TextStyle(fontSize: 14, color: colorGreyShade600),
                ),
              ),
            ],
          ),
          onTap: () async {
            if (emailAddresses.isNotEmpty) {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: emailAddresses.join(','),
              );
              await launchUrl(emailUri);
            }
          },
        ),
      ),
    ],
  );
}

Widget webSite() {
  return Column(
    children: [
      Container(
        color: lightGreenBackground,
        child: ListTile(
          minTileHeight: 4.0,
          contentPadding: const EdgeInsets.only(left: 4),
          title: Row(
            children: [
              Icon(Icons.public, color: appColor, size: 18),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'www.darshan.ac.in',
                  style: TextStyle(fontSize: 14, color: colorGreyShade600),
                ),
              ),
            ],
          ),
          onTap: () async {
            String url = 'www.darshan.ac.in';
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              url = 'https://$url';
            }
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          },
        ),
      ),
    ],
  );
}