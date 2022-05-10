import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide Transform;
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_manipulation/image_manipulation.dart';
import 'package:image_manipulation_example/widgets/filter_list.dart';
import 'package:image_manipulation_example/widgets/image_memory_with_loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

const listedMonochromeFilters = [
  Monochrome.grayscale(),
  Monochrome.sepia(),
  Monochrome.blueGrayscale(),
  Monochrome.greenGrayscale(),
  Monochrome.redGrayscale(),
  Monochrome.decomposeMax(),
  Monochrome.decomposeMin(),
  Monochrome.grayscaleHumanCorrection(),
  Monochrome.grayscaleShades(1),
  Monochrome.threshold(100),
];

const listedPresetFilters = [
  PresetFilter.oceanic(),
  PresetFilter.islands(),
  PresetFilter.marine(),
  PresetFilter.seagreen(),
  PresetFilter.flagblue(),
  PresetFilter.diamante(),
  PresetFilter.liquid(),
  PresetFilter.vintage(),
  PresetFilter.perfume(),
  PresetFilter.serenity(),
  PresetFilter.golden(),
  PresetFilter.pastelPink(),
  PresetFilter.cali(),
  PresetFilter.dramatic(),
  PresetFilter.firenze(),
  PresetFilter.obsidian(),
  PresetFilter.lofi(),
];

const listedTintFilters = [
  Tint.radio(),
  Tint.twenties(),
  Tint.rosetint(),
  Tint.mauve(),
  Tint.bluechrome(),
];

const listedChannelFilters = [
  Channel.incBlueChannel(),
  Channel.incGreenChannel(),
  Channel.incRedChannel(),
  Channel.inc2Channels(),
  Channel.decBlueChannel(),
  Channel.decGreenChannel(),
  Channel.decRedChannel(),
  Channel.swapBGChannels(),
  Channel.swapRBChannels(),
  Channel.swapRGChannels(),
  Channel.removeBlueChannel(),
  Channel.removeGreenChannel(),
  Channel.removeRedChannel(),
];

const listedColourSpaceFilters = [
  ColourSpace.hsl(level: 0.3, mode: ColourSpaceMode.darken),
  ColourSpace.hsl(level: 0.3, mode: ColourSpaceMode.desaturate),
  ColourSpace.hsl(level: 0.3, mode: ColourSpaceMode.lighten),
  ColourSpace.hsl(level: 0.3, mode: ColourSpaceMode.saturate),
  ColourSpace.hsl(level: 0.3, mode: ColourSpaceMode.shift_hue),
  ColourSpace.hsv(level: 0.3, mode: ColourSpaceMode.darken),
  ColourSpace.hsv(level: 0.3, mode: ColourSpaceMode.desaturate),
  ColourSpace.hsv(level: 0.3, mode: ColourSpaceMode.lighten),
  ColourSpace.hsv(level: 0.3, mode: ColourSpaceMode.saturate),
  ColourSpace.hsv(level: 0.3, mode: ColourSpaceMode.shift_hue),
  ColourSpace.lch(level: 0.3, mode: ColourSpaceMode.darken),
  ColourSpace.lch(level: 0.3, mode: ColourSpaceMode.desaturate),
  ColourSpace.lch(level: 0.3, mode: ColourSpaceMode.lighten),
  ColourSpace.lch(level: 0.3, mode: ColourSpaceMode.saturate),
  ColourSpace.lch(level: 0.3, mode: ColourSpaceMode.shift_hue),
  ColourSpace.mixWithColour(opacity: .5, rgb: Rgb(r: 10, g: 20, b: 43)),
];

const listedEffectFilters = [
  Effect.adjustContrast(contrast: 100),
  Effect.colorHorizontalStrips(length: 4, rgb: Rgb(r: 100, g: 100, b: 100)),
  Effect.colorVerticalStrips(length: 4, rgb: Rgb(r: 100, g: 100, b: 100)),
  Effect.colorize(),
  Effect.frostedGlass(),
  Effect.halftone(),
  Effect.primary(),
  Effect.solarize(),
  Effect.incBrightness(brightness: 50),
  Effect.multipleOffsets(offset: 20, channelIndex2: 2, channelIndex: 1),
  Effect.offset(offset: 10, channelIndex: 0),
  Effect.offset(offset: 10, channelIndex: 1),
  Effect.offset(offset: 10, channelIndex: 2),
  Effect.oil(intensity: 1, radius: 5),
  Effect.tint(rOffset: 20, bOffset: 20, gOffset: 20),
];

const listedConvolutionFilters = [
  Convolution.boxBlur(),
  Convolution.detect45DegLines(),
  Convolution.detect135DegLines(),
  Convolution.detectVerticalLines(),
  Convolution.detectHorizontalLines(),
  Convolution.edgeDetection(),
  Convolution.edgeOne(),
  Convolution.emboss(),
  Convolution.identity(),
  Convolution.laplace(),
  Convolution.noiseReduction(),
  Convolution.prewittHorizontal(),
  Convolution.sharpen(),
  Convolution.sobelHorizontal(),
  Convolution.sobelVertical(),
  Convolution.gaussianBlur(
    radius: 20,
  ),
];

Future<List<Filter>> listedMultipleFilters() async {
  final watermark = await rootBundle.load('images/watermark.png');
  final blendImage = await rootBundle.load('images/blend.jpg');
  return [
    Multiple.watermarkFromBytes(
      x: 20,
      y: 20,
      bytes: Uint8List.view(
        watermark.buffer,
        watermark.offsetInBytes,
        watermark.lengthInBytes,
      ),
    ),
    const Multiple.applyGradient(),
    Multiple.replaceBackground(
      bytes: Uint8List.view(
        blendImage.buffer,
        blendImage.offsetInBytes,
        blendImage.lengthInBytes,
      ),
      rgb: const Rgb(
        r: 1,
        g: 255,
        b: 19,
      ),
    ),
    ...BlendMode.values.map((e) {
      return Multiple.blend(
        bytes: Uint8List.view(
          blendImage.buffer,
          blendImage.offsetInBytes,
          blendImage.lengthInBytes,
        ),
        blendMode: e,
      );
    }).toList(),
  ];
}

const listedTransformationFilters = [
  Transform.crop(
    x1: 20,
    y1: 20,
    x2: 1000,
    y2: 1000,
  ),
  Transform.flipH(),
  Transform.flipV(),
  Transform.paddingBottom(
    color: Colors.blue,
    padding: 20,
  ),
  Transform.paddingTop(
    color: Colors.blue,
    padding: 50,
  ),
  Transform.paddingRight(
    color: Colors.blue,
    padding: 50,
  ),
  Transform.paddingLeft(
    color: Colors.blue,
    padding: 50,
  ),
  Transform.paddingUniform(
    color: Colors.blue,
    padding: 50,
  ),
  Transform.resize(
    height: 300,
    width: 200,
    samplingFilter: SamplingFilter.nearest,
  ),
  Transform.resize(
    height: 300,
    width: 200,
    samplingFilter: SamplingFilter.catmullRom,
  ),
  Transform.resize(
    height: 300,
    width: 200,
    samplingFilter: SamplingFilter.gaussian,
  ),
  Transform.resize(
    height: 300,
    width: 200,
    samplingFilter: SamplingFilter.lanczos3,
  ),
  Transform.resize(
    height: 300,
    width: 200,
    samplingFilter: SamplingFilter.triangle,
  ),
];

class _MyAppState extends State<MyApp> {
  ValueNotifier<Uint8List?> originalImage = ValueNotifier(null);
  Uint8List? processedImage;
  ValueNotifier<Set<Filter>> filters = ValueNotifier({});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Manipulation Example'),
          actions: [
            IconButton(
              onPressed: () async {
                if (processedImage == null) return;

                final data = await ImageGallerySaver.saveImage(
                  processedImage!,
                );
              },
              icon: const Icon(
                Icons.download,
              ),
            )
          ],
        ),
        body: Builder(builder: (context) {
          return ListView(
            cacheExtent: 999999,
            children: [
              ValueListenableBuilder<Uint8List?>(
                valueListenable: originalImage,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Set<Filter>>(
                    valueListenable: filters,
                    builder: (context, filters, child) {
                      if (value == null || filters.isNotEmpty) {
                        return Container();
                      }

                      if (filters.isEmpty) {
                        return ImageMemoryWithLoading(
                          image: value,
                          width: MediaQuery.of(context).size.width,
                        );
                      }

                      return Container();
                    },
                  );
                },
              ),
              ValueListenableBuilder<Set<Filter>>(
                valueListenable: filters,
                builder: (context, value, child) {
                  if (originalImage.value == null || filters.value.isEmpty) {
                    return Container();
                  }
                  Stopwatch? stopwatch;

                  return FutureBuilder<Uint8List>(
                    future: ImageManipulation.manipulate(
                      bytes: originalImage.value!,
                      filters: value.toList(),
                      outputFormat: OutputFormat.Jpeg,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        stopwatch = Stopwatch()..start();
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        stopwatch ??= Stopwatch()..start();
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        stopwatch?.stop();
                      }
                      processedImage = snapshot.data;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageMemoryWithLoading(
                            image: snapshot.data == null ? originalImage.value! : snapshot.data!,
                            width: MediaQuery.of(context).size.width,
                            timeInMs: stopwatch?.elapsedMilliseconds,
                          ),
                          if (snapshot.data == null) const CircularProgressIndicator(),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Monochrome Filter',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedMonochromeFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Preset Filter',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedPresetFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Tints',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedTintFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Channels',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedChannelFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Transformation',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedTransformationFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Multiple',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FutureBuilder<List<Filter>>(
                        future: listedMultipleFilters(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return FilterList(
                            filters: filters,
                            listedFilters: snapshot.data ?? [],
                            originalImage: originalImage,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Effects',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedEffectFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Colour Spaces',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedColourSpaceFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: originalImage,
                      builder: (context, value, child) {
                        if (value == null) return Container();
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            'Convolution',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: FilterList(
                        filters: filters,
                        listedFilters: listedConvolutionFilters,
                        originalImage: originalImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final _picker = ImagePicker();
            final image = await _picker.getImage(
              source: ImageSource.gallery,
            );

            if (image != null) {
              final imageBytes = await image.readAsBytes();
              originalImage.value = imageBytes;
              setState(() {});
              log(originalImage.value?.length.toString() ?? '');
            }
          },
          child: const Icon(Icons.image),
        ),
      ),
    );
  }
}
