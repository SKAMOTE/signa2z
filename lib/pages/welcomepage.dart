import "package:flutter/material.dart";
import "../styles/welcomepagestyle.dart";

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WelcomePageColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text("WELCOME TO SIGNA2Z",
                        style: WelcomePageTextStyles.heading,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 1),
                    const Text("Bridging the gap between the",
                        style: WelcomePageTextStyles.subtitle,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 1),
                    const Text("Deaf and hearing.",
                        style: WelcomePageTextStyles.subtitle,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 90),
                    Image.asset("assets/images/app_logo.png",
                        width: 210, height: 105, fit: BoxFit.contain),
                    const SizedBox(height: 120),

                    // SIGN UP button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: WelcomePageButtonStyles.roundedBlue,
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: const Text("SIGN UP",
                            style: WelcomePageTextStyles.button),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // LOGIN button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: WelcomePageButtonStyles.roundedBlue,
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: const Text("LOG IN",
                            style: WelcomePageTextStyles.button),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom image
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/asl.png",
                width: MediaQuery.of(context).size.width,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
