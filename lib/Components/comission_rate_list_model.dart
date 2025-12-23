class ComissionRateListModel {
  ComissionRateListModel({
    required this.message,
    required this.status,
    required this.model,
  });
  late final String message;
  late final bool status;
  late final List<ComissionRateModel> model;

  ComissionRateListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    model = List.from(
      json['model'],
    ).map((e) => ComissionRateModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['model'] = model.map((e) => e.toJson()).toList();
    return data;
  }
}

class ComissionRateModel {
  ComissionRateModel({
    required this.id,
    required this.minimumHours,
    required this.maximumHours,
    required this.rate,
  });
  late final Id id;
  late final int minimumHours;
  late final int maximumHours;
  late final double rate;

  ComissionRateModel.fromJson(Map<String, dynamic> json) {
    id = Id.fromJson(json['id']);
    minimumHours = json['minimumHours'];
    maximumHours = json['maximumHours'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id.toJson();
    data['minimumHours'] = minimumHours;
    data['maximumHours'] = maximumHours;
    data['rate'] = rate;
    return data;
  }
}

class Id {
  Id({required this.value});
  late final String value;

  Id.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}
