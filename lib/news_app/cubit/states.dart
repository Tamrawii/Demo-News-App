abstract class NewsAppStates {}

class AppInitialState extends NewsAppStates {}

class AppChangeNavBar extends NewsAppStates {}

class NewsBusinesGetLoadingState extends NewsAppStates {}

class NewsBusinesGetSuccessState extends NewsAppStates {}

class NewsBusinesGetErrorState extends NewsAppStates {
  final String error;

  NewsBusinesGetErrorState(this.error);
}

class NewsScienceGetLoadingState extends NewsAppStates {}

class NewsScienceGetSuccessState extends NewsAppStates {}

class NewsScienceGetErrorState extends NewsAppStates {
  final String error;

  NewsScienceGetErrorState(this.error);
}

class NewsSportsGetLoadingState extends NewsAppStates {}

class NewsSportsGetSuccessState extends NewsAppStates {}

class NewsSportsGetErrorState extends NewsAppStates {
  final String error;

  NewsSportsGetErrorState(this.error);
}

class NewsChangeMode extends NewsAppStates {}