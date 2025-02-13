abstract class AllStoresStates {}

final class AllStoresInitial extends AllStoresStates {}

class AllStoresLoadingState extends AllStoresStates {}

class AllStoresSuccessState extends AllStoresStates {}

class AllStoresErrorState extends AllStoresStates {}

class AllProductsLodingState extends AllStoresStates {}

class AllProductsSuccessState extends AllStoresStates {}

class AllProductsErroeState extends AllStoresStates {}

class UserStoreLodingState extends AllStoresStates {}

class UserStoreSuccessState extends AllStoresStates {}

class UserStoreErroeState extends AllStoresStates {
  UserStoreErroeState(this.noStore);
  bool noStore;
}

class GetStoreLoadingState extends AllStoresStates {}

class GetStoreSuccessState extends AllStoresStates {}

class GetStoreErrorState extends AllStoresStates {}

class GetProductDetailsLodingState extends AllStoresStates {}

class GetProductDetailsSuccessState extends AllStoresStates {}

class GetProductDetailsErroeState extends AllStoresStates {}

class RatingProductLodingState extends AllStoresStates {}

class RatingProductSuccessState extends AllStoresStates {}

class RatingProductErroeState extends AllStoresStates {}

class RatingSroreLodingState extends AllStoresStates {}

class RatingSroreSuccessState extends AllStoresStates {}

class RatingSroreErroeState extends AllStoresStates {}
