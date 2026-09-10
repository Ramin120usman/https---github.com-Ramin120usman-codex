import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_details_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<ProductDetailsProvider>()
          .loadProduct(widget.productId);

      context.read<WishlistProvider>().loadWishlist();
    });
  }

  Future<void> _addToCart() async {
    final product =
        context.read<ProductDetailsProvider>().product;

    if (product == null) return;

    if (product.storeId == null ||
        product.storeId!.isEmpty) {
      _showMessage(
        'Store information is not available',
      );
      return;
    }

    if (product.productType == null ||
        product.productType!.isEmpty) {
      _showMessage(
        'Product type is not available',
      );
      return;
    }

    final cartProvider = context.read<CartProvider>();

    final success = await cartProvider.addToCart(
      storeId: product.storeId!,
      productId: product.id,
      productType: product.productType!,
      qty: 1,
    );

    if (!mounted) return;

    if (success) {
      _showMessage('Product added to cart');
    } else {
      _showMessage(
        cartProvider.errorMessage ??
            'Failed to add product to cart',
      );
    }
  }

  Future<void> _toggleWishlist() async {
    final product =
        context.read<ProductDetailsProvider>().product;

    if (product == null) return;

    final wishlistProvider =
        context.read<WishlistProvider>();

    final isWishlisted =
        wishlistProvider.isWishlisted(product.id);

    bool success;

    if (isWishlisted) {
      success = await wishlistProvider.removeFromWishlist(
        product.id,
      );
    } else {
      success = await wishlistProvider.addToWishlist(
        productId: product.id,
      );
    }

    if (!mounted) return;

    if (success) {
      _showMessage(
        isWishlisted
            ? 'Removed from wishlist'
            : 'Added to wishlist',
      );
    } else {
      _showMessage(
        wishlistProvider.errorMessage ??
            'Wishlist operation failed',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Consumer<ProductDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final product = provider.product;

          if (product == null) {
            return const Center(
              child: Text('Product not found'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null &&
                    product.imageUrl!.isNotEmpty)
                  Image.network(
                    product.imageUrl!,
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return const SizedBox(
                        height: 320,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  )
                else
                  const SizedBox(
                    height: 320,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (product.price != null)
                        Text(
                          '₹${product.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      const SizedBox(height: 25),

                      // Add to Cart
                      Consumer<CartProvider>(
                        builder: (
                          context,
                          cartProvider,
                          child,
                        ) {
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed:
                                  cartProvider.isUpdating
                                      ? null
                                      : _addToCart,
                              icon: cartProvider.isUpdating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons
                                          .shopping_cart_outlined,
                                    ),
                              label: Text(
                                cartProvider.isUpdating
                                    ? 'Adding...'
                                    : 'Add to Cart',
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Wishlist
                      Consumer<WishlistProvider>(
                        builder: (
                          context,
                          wishlistProvider,
                          child,
                        ) {
                          final isWishlisted =
                              wishlistProvider
                                  .isWishlisted(product.id);

                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child:
                                OutlinedButton.icon(
                              onPressed:
                                  wishlistProvider
                                          .isUpdating
                                      ? null
                                      : _toggleWishlist,
                              icon: wishlistProvider
                                      .isUpdating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      isWishlisted
                                          ? Icons.favorite
                                          : Icons
                                              .favorite_border,
                                    ),
                              label: Text(
                                isWishlisted
                                    ? 'Remove from Wishlist'
                                    : 'Add to Wishlist',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}