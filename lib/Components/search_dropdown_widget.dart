import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class GenericSearchDropdown<T> extends StatelessWidget {
  final String label;
  final Future<List<T>> Function(String filter)? asyncItems;
  final String Function(T item) itemAsString;
  final void Function(T? value)? onChanged;
  final T? selectedItem;
  final bool isEnabled;

  const GenericSearchDropdown({
    super.key,
    required this.label,
    required this.itemAsString,
    this.asyncItems,
    this.onChanged,
    this.selectedItem,
    this.isEnabled = true,
  });

  bool _compareFn(T? a, T? b) {
    if (a == null || b == null) return false;
    try {
      final aMap = a as dynamic;
      final bMap = b as dynamic;

      if (aMap.vehicleCode != null && bMap.vehicleCode != null) {
        return aMap.vehicleCode == bMap.vehicleCode;
      }
      if (aMap.vehicleNo != null && bMap.vehicleNo != null) {
        return aMap.vehicleNo == bMap.vehicleNo;
      }
      if (aMap.detailCode != null && bMap.detailCode != null) {
        return aMap.detailCode == bMap.detailCode;
      }
      if (aMap.costCenterId != null && bMap.costCenterId != null) {
        return aMap.costCenterId == bMap.costCenterId;
      }
      if (aMap.warehouseId != null && bMap.warehouseId != null) {
        return aMap.warehouseId == bMap.warehouseId;
      }
    } catch (_) {}
    return a.toString() == b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        DropdownSearch<T>(
          enabled: isEnabled,
          items: asyncItems != null
              ? (String filter, _) async {
                  try {
                    final results = await asyncItems!(filter);
                    return results;
                  } catch (e) {
                    debugPrint("Error loading dropdown data: $e");
                    return [];
                  }
                }
              : null,
          itemAsString: itemAsString,
          selectedItem: selectedItem,
          compareFn: _compareFn,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            loadingBuilder: (context, searchEntry) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            emptyBuilder: (context, searchEntry) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          onChanged: onChanged,
        ),

        // 👇 Clear (Cancel) Icon
        if (selectedItem != null)
          Positioned(
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 20),
              onPressed: () {
                onChanged?.call(null);
              },
              tooltip: 'Clear selection',
            ),
          ),
      ],
    );
  }
}
