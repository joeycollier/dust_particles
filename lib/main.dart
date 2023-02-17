import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(MyApp());

// To add a more natural movement, place the animation in a box
// give the ParticleBox some movement & rotation
class ParticleBox extends StatelessWidget {
  const ParticleBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // LoopAnimationBuilder plays forever: from beginning to end
    return LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 60), // set the speed of the animation
      // the curve gives some fluidity, but is a performance hog, so disabled
      // curve: Curves.easeInOutSine,
      builder: (context, value, _) {
        return Transform.rotate(
          angle: value * 2 * 3.14,
          child: Transform.translate(
            offset: Offset(0.0, 50.0 * (1 - value * 5) * sin(value * 10 * pi)),
            //child: Container( child: DustParticles(), decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 5,  )),),  // enable to view the animation
            child: Container( child: DustParticles() ),  // place the DustParticles animation inside the ParticleBox
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dust Particles Animation',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(child: ParticleBox()), // Change to DustParticles() to see w/o extra movement & rotation
      ),
    );
  }
}

class DustParticles extends StatefulWidget {
  @override
  _DustParticlesState createState() => _DustParticlesState();
}

class _DustParticlesState extends State<DustParticles> {
  final _random = Random();
  final _particles = List.generate(18, (index) => _Particle()); // set the number of particles here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // LoopAnimationBuilder plays forever: from beginning to end
      body: LoopAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 2 * pi),
        //curve: Curves.elasticInOut,
        duration: Duration(seconds: 30), // set the speed of the animation
        builder: (context, value, child) {
          return Stack(
            children: _particles.map((particle) {
              return Positioned(
                left: particle.x + sin(2 * value + particle.offset) * particle.amplitude,
                top: particle.y + cos(2 * value + particle.offset) * particle.amplitude,
                child: Opacity(
                  opacity: particle.opacity * _random.nextDouble(), // random double added to make flicker opacity
                  //child: Container(width: particle.size, height: particle.size, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(100) ) ),
                  child: Image.asset('assets/dust.png', width: particle.size, height: particle.size),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (var particle in _particles) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        particle.x = _random.nextDouble() * MediaQuery.of(context).size.width;
        particle.y = _random.nextDouble() * MediaQuery.of(context).size.height;
        particle.offset = _random.nextDouble() * 2 * pi;
        particle.amplitude = _random.nextDouble() * 50 + 50;
        particle.opacity = _random.nextDouble() * 0.5; // increase for more opacity, decrease for less;
        particle.size = _random.nextDouble() * 40; // change to adjust particle size
      });
    }
  }
}

class _Particle {
  // set starting values to zero, to be set during initState()
  double x = 0;
  double y = 0;
  double offset = 0;
  double amplitude = 0;
  double opacity = 0;
  double size = 0;
}
