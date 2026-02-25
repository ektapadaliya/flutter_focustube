import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/note_model.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  NoteController();

  static final List<NoteModel> _notes = [];
  List<NoteModel> notes = _notes;

  void addNotes(List<NoteModel> notes) {
    for (var element in notes) {
      addNote(element);
    }
  }

  void addNote(NoteModel note) {
    var index = _notes.indexWhere((e) => e.id == note.id);
    if (index == -1) {
      _notes.add(note);
    } else {
      _notes[index] = note;
    }
    update();
  }

  LoaderController get loaderController =>
      controller<LoaderController>(tag: "note-list");
  void setIsLoading(bool isLoading) {
    controller<LoaderController>(tag: "note-list").setLoading(isLoading);
  }

  static bool _hasData = true;
  bool get hasData => _hasData;

  void setHasData(bool hasData) {
    _hasData = hasData;
    update();
  }

  static int _page = 1;
  int get page => _page;

  void incPage() {
    _page++;
    update();
  }

  void removeNote(String id) {
    _notes.removeWhere((e) => e.id.toString() == id);
    update();
  }

  void clear() {
    _notes.clear();
    _page = 1;
    _hasData = true;
    loaderController.setLoading(false);
    update();
  }
}
