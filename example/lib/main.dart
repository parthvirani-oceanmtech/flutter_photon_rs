import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_manipulation/image_manipulation.dart';
import 'package:image_manipulation_example/widgets/filter_list.dart';
import 'package:image_manipulation_example/widgets/image_memory_with_loading.dart';
import 'package:image_picker/image_picker.dart';

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

                final dynamic data = await ImageGallerySaver.saveImage(
                  processedImage!,
                );
                log(data.toString());
              },
              icon: const Icon(
                Icons.download,
              ),
            )
          ],
        ),
        body: Builder(builder: (context) {
          return ListView(
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

                  return FutureBuilder<Uint8List>(
                    future: ImageManipulation.manipulate(
                      bytes: originalImage.value!,
                      filters: value.toList(),
                      outputFormat: OutputFormat.Jpeg,
                    ),
                    builder: (context, snapshot) {
                      processedImage = snapshot.data;
                      return ImageMemoryWithLoading(
                        image: snapshot.data == null ? originalImage.value! : snapshot.data!,
                        width: MediaQuery.of(context).size.width,
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
