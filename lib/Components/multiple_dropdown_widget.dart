import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class SimpleMultiSelectDropdown<T> extends StatelessWidget {
//   final String label;
//   final String? hint;
//   final List<T> items;
//   final List<T> selectedItems;
//   final ValueChanged<List<T>>? onChanged;
//   final String Function(T)? displayProperty;

//   const SimpleMultiSelectDropdown({
//     super.key,
//     required this.label,
//     this.hint,
//     required this.items,
//     required this.selectedItems,
//     required this.onChanged,
//     this.displayProperty,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final selectedText =
//         selectedItems.isNotEmpty
//             ? selectedItems
//                 .map((e) => displayProperty?.call(e) ?? e.toString())
//                 .join(', ')
//             : (hint ?? "Select $label");

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: EdgeInsets.only(left: 10),
//           child: Text(
//             label,
//             style: GoogleFonts.outfit(fontSize: 12, color: Colors.black),
//           ),
//         ),
//         const SizedBox(height: 5),
//         PopupMenuButton<T>(
//           padding: EdgeInsets.all(20),
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           shape: OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//             borderSide: BorderSide(
//               color: Color(0xFFD9D9D9),
//               strokeAlign: 1,
//               width: 1,
//             ),
//           ),
//           onSelected: (_) {},
//           itemBuilder: (context) {
//             return items.map((item) {
//               final isSelected = selectedItems.contains(item);
//               return
//               PopupMenuItem<T>(
//                 value: item,
//                 child: StatefulBuilder(
//                   builder:
//                       (context, setState) => CheckboxListTile(
//                         controlAffinity: ListTileControlAffinity.leading,
//                         contentPadding: EdgeInsets.zero,
//                         value: isSelected,
//                         title: Text(
//                           displayProperty?.call(item) ?? item.toString(),
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         onChanged: (checked) {
//                           final updatedList = List<T>.from(selectedItems);
//                           if (checked == true) {
//                             updatedList.add(item);
//                           } else {
//                             updatedList.remove(item);
//                           }
//                           onChanged?.call(updatedList);
//                           Navigator.pop(context); // Close after change
//                         },
//                       ),
//                 ),
//               );
//             }).toList();
//           },
//           child: InputDecorator(
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 borderSide: BorderSide(
//                   color: Color(0xFFD9D9D9), // Your desired color
//                   width: 1,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 borderSide: BorderSide(
//                   color: Color(0xFFD9D9D9), // Same color here
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 borderSide: BorderSide(
//                   color: Color(
//                     0xFFD9D9D9,
//                   ), // Optional: change if you want a focus color
//                   width: 1,
//                 ),
//               ),
//               contentPadding: EdgeInsets.all(20),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     selectedText,
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ),
//                 const Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   size: 24,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class SimpleMultiSelectDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final List<T> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>>? onChanged;
  final String Function(T)? displayProperty;

  const SimpleMultiSelectDropdown({
    super.key,
    required this.label,
    this.hint,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.displayProperty,
  });

  @override
  Widget build(BuildContext context) {
    final selectedText = selectedItems.isNotEmpty
        ? selectedItems
              .map((e) => displayProperty?.call(e) ?? e.toString())
              .join(', ')
        : (hint ?? "Select $label");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black),
          ),
        ),
        const SizedBox(height: 5),
        PopupMenuButton<T>(
          // padding: const EdgeInsets.all(20),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 1),
          ),
          onSelected: (_) {}, // Required even if not used
          itemBuilder: (context) {
            final fullWidth = MediaQuery.of(context).size.width;

            return items.map((item) {
              final isSelected = selectedItems.contains(item);
              return PopupMenuItem<T>(
                value: item,
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: fullWidth,
                  child: StatefulBuilder(
                    builder: (context, setState) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      value: isSelected,
                      title: Text(
                        displayProperty?.call(item) ?? item.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      onChanged: (checked) {
                        final updatedList = List<T>.from(selectedItems);
                        if (checked == true) {
                          updatedList.add(item);
                        } else {
                          updatedList.remove(item);
                        }
                        onChanged?.call(updatedList);
                        Navigator.pop(
                          context,
                        ); // Close the menu after selection
                      },
                    ),
                  ),
                ),
              );
            }).toList();
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 1),
              ),
              contentPadding: EdgeInsets.all(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedText,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
