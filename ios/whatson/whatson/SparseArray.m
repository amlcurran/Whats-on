//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: core/src/main/java//uk/co/amlcurran/social/core/SparseArray.java
//

#include "ContainerHelpers.h"
#include "IOSClass.h"
#include "IOSObjectArray.h"
#include "IOSPrimitiveArray.h"
#include "J2ObjC_source.h"
#include "SparseArray.h"
#include "java/lang/CloneNotSupportedException.h"
#include "java/lang/Math.h"
#include "java/lang/StringBuilder.h"
#include "java/lang/System.h"

@interface UkCoAmlcurranSocialCoreSparseArray () {
 @public
  jboolean mGarbage_;
  IOSIntArray *mKeys_;
  IOSObjectArray *mValues_;
  jint mSize_;
}

- (void)gc;

@end

J2OBJC_FIELD_SETTER(UkCoAmlcurranSocialCoreSparseArray, mKeys_, IOSIntArray *)
J2OBJC_FIELD_SETTER(UkCoAmlcurranSocialCoreSparseArray, mValues_, IOSObjectArray *)

inline id UkCoAmlcurranSocialCoreSparseArray_get_DELETED();
static id UkCoAmlcurranSocialCoreSparseArray_DELETED;
J2OBJC_STATIC_FIELD_OBJ_FINAL(UkCoAmlcurranSocialCoreSparseArray, DELETED, id)

__attribute__((unused)) static void UkCoAmlcurranSocialCoreSparseArray_gc(UkCoAmlcurranSocialCoreSparseArray *self);

J2OBJC_INITIALIZED_DEFN(UkCoAmlcurranSocialCoreSparseArray)

@implementation UkCoAmlcurranSocialCoreSparseArray

J2OBJC_IGNORE_DESIGNATED_BEGIN
- (instancetype)init {
  UkCoAmlcurranSocialCoreSparseArray_init(self);
  return self;
}
J2OBJC_IGNORE_DESIGNATED_END

- (instancetype)initWithInt:(jint)initialCapacity {
  UkCoAmlcurranSocialCoreSparseArray_initWithInt_(self, initialCapacity);
  return self;
}

- (UkCoAmlcurranSocialCoreSparseArray *)java_clone {
  UkCoAmlcurranSocialCoreSparseArray *clone = nil;
  @try {
    clone = (UkCoAmlcurranSocialCoreSparseArray *) cast_chk([super java_clone], [UkCoAmlcurranSocialCoreSparseArray class]);
    ((UkCoAmlcurranSocialCoreSparseArray *) nil_chk(clone))->mKeys_ = [((IOSIntArray *) nil_chk(mKeys_)) java_clone];
    clone->mValues_ = [((IOSObjectArray *) nil_chk(mValues_)) java_clone];
  }
  @catch (JavaLangCloneNotSupportedException *cnse) {
  }
  return clone;
}

- (id)getWithInt:(jint)key {
  return [self getWithInt:key withId:nil];
}

- (id)getWithInt:(jint)key
          withId:(id)valueIfKeyNotFound {
  jint i = UkCoAmlcurranSocialCoreContainerHelpers_binarySearchWithIntArray_withInt_withInt_(mKeys_, mSize_, key);
  if (i < 0 || IOSObjectArray_Get(nil_chk(mValues_), i) == UkCoAmlcurranSocialCoreSparseArray_DELETED) {
    return valueIfKeyNotFound;
  }
  else {
    return IOSObjectArray_Get(nil_chk(mValues_), i);
  }
}

- (void)delete__WithInt:(jint)key {
  jint i = UkCoAmlcurranSocialCoreContainerHelpers_binarySearchWithIntArray_withInt_withInt_(mKeys_, mSize_, key);
  if (i >= 0) {
    if (IOSObjectArray_Get(nil_chk(mValues_), i) != UkCoAmlcurranSocialCoreSparseArray_DELETED) {
      (void) IOSObjectArray_Set(mValues_, i, UkCoAmlcurranSocialCoreSparseArray_DELETED);
      mGarbage_ = true;
    }
  }
}

- (void)removeWithInt:(jint)key {
  [self delete__WithInt:key];
}

- (void)removeAtWithInt:(jint)index {
  if (IOSObjectArray_Get(nil_chk(mValues_), index) != UkCoAmlcurranSocialCoreSparseArray_DELETED) {
    (void) IOSObjectArray_Set(mValues_, index, UkCoAmlcurranSocialCoreSparseArray_DELETED);
    mGarbage_ = true;
  }
}

- (void)removeAtRangeWithInt:(jint)index
                     withInt:(jint)size {
  jint end = JavaLangMath_minWithInt_withInt_(mSize_, index + size);
  for (jint i = index; i < end; i++) {
    [self removeAtWithInt:i];
  }
}

- (void)gc {
  UkCoAmlcurranSocialCoreSparseArray_gc(self);
}

- (void)putWithInt:(jint)key
            withId:(id)value {
  jint i = UkCoAmlcurranSocialCoreContainerHelpers_binarySearchWithIntArray_withInt_withInt_(mKeys_, mSize_, key);
  if (i >= 0) {
    (void) IOSObjectArray_Set(nil_chk(mValues_), i, value);
  }
  else {
    i = ~i;
    if (i < mSize_ && IOSObjectArray_Get(nil_chk(mValues_), i) == UkCoAmlcurranSocialCoreSparseArray_DELETED) {
      *IOSIntArray_GetRef(nil_chk(mKeys_), i) = key;
      (void) IOSObjectArray_Set(nil_chk(mValues_), i, value);
      return;
    }
    if (mGarbage_ && mSize_ >= ((IOSIntArray *) nil_chk(mKeys_))->size_) {
      UkCoAmlcurranSocialCoreSparseArray_gc(self);
      i = ~UkCoAmlcurranSocialCoreContainerHelpers_binarySearchWithIntArray_withInt_withInt_(mKeys_, mSize_, key);
    }
    if (mSize_ >= ((IOSIntArray *) nil_chk(mKeys_))->size_) {
      jint n = UkCoAmlcurranSocialCoreContainerHelpers_idealIntArraySizeWithInt_(mSize_ + 1);
      IOSIntArray *nkeys = [IOSIntArray newArrayWithLength:n];
      IOSObjectArray *nvalues = [IOSObjectArray newArrayWithLength:n type:NSObject_class_()];
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mKeys_, 0, nkeys, 0, ((IOSIntArray *) nil_chk(mKeys_))->size_);
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mValues_, 0, nvalues, 0, ((IOSObjectArray *) nil_chk(mValues_))->size_);
      mKeys_ = nkeys;
      mValues_ = nvalues;
    }
    if (mSize_ - i != 0) {
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mKeys_, i, mKeys_, i + 1, mSize_ - i);
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mValues_, i, mValues_, i + 1, mSize_ - i);
    }
    *IOSIntArray_GetRef(nil_chk(mKeys_), i) = key;
    (void) IOSObjectArray_Set(nil_chk(mValues_), i, value);
    mSize_++;
  }
}

- (jint)size {
  if (mGarbage_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  return mSize_;
}

- (jint)keyAtWithInt:(jint)index {
  if (mGarbage_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  return IOSIntArray_Get(nil_chk(mKeys_), index);
}

- (id)valueAtWithInt:(jint)index {
  if (mGarbage_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  return IOSObjectArray_Get(nil_chk(mValues_), index);
}

- (void)setValueAtWithInt:(jint)index
                   withId:(id)value {
  if (mGarbage_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  (void) IOSObjectArray_Set(nil_chk(mValues_), index, value);
}

- (jint)indexOfKeyWithInt:(jint)key {
  if (mGarbage_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  return UkCoAmlcurranSocialCoreContainerHelpers_binarySearchWithIntArray_withInt_withInt_(mKeys_, mSize_, key);
}

- (jint)indexOfValueWithId:(id)value {
  if (mGarbage_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  for (jint i = 0; i < mSize_; i++) if (IOSObjectArray_Get(nil_chk(mValues_), i) == value) return i;
  return -1;
}

- (void)clear {
  jint n = mSize_;
  IOSObjectArray *values = mValues_;
  for (jint i = 0; i < n; i++) {
    (void) IOSObjectArray_Set(nil_chk(values), i, nil);
  }
  mSize_ = 0;
  mGarbage_ = false;
}

- (void)appendWithInt:(jint)key
               withId:(id)value {
  if (mSize_ != 0 && key <= IOSIntArray_Get(nil_chk(mKeys_), mSize_ - 1)) {
    [self putWithInt:key withId:value];
    return;
  }
  if (mGarbage_ && mSize_ >= ((IOSIntArray *) nil_chk(mKeys_))->size_) {
    UkCoAmlcurranSocialCoreSparseArray_gc(self);
  }
  jint pos = mSize_;
  if (pos >= ((IOSIntArray *) nil_chk(mKeys_))->size_) {
    jint n = UkCoAmlcurranSocialCoreContainerHelpers_idealIntArraySizeWithInt_(pos + 1);
    IOSIntArray *nkeys = [IOSIntArray newArrayWithLength:n];
    IOSObjectArray *nvalues = [IOSObjectArray newArrayWithLength:n type:NSObject_class_()];
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mKeys_, 0, nkeys, 0, ((IOSIntArray *) nil_chk(mKeys_))->size_);
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mValues_, 0, nvalues, 0, ((IOSObjectArray *) nil_chk(mValues_))->size_);
    mKeys_ = nkeys;
    mValues_ = nvalues;
  }
  *IOSIntArray_GetRef(mKeys_, pos) = key;
  (void) IOSObjectArray_Set(nil_chk(mValues_), pos, value);
  mSize_ = pos + 1;
}

- (NSString *)description {
  if ([self size] <= 0) {
    return @"{}";
  }
  JavaLangStringBuilder *buffer = new_JavaLangStringBuilder_initWithInt_(mSize_ * 28);
  (void) [buffer appendWithChar:'{'];
  for (jint i = 0; i < mSize_; i++) {
    if (i > 0) {
      (void) [buffer appendWithNSString:@", "];
    }
    jint key = [self keyAtWithInt:i];
    (void) [buffer appendWithInt:key];
    (void) [buffer appendWithChar:'='];
    id value = [self valueAtWithInt:i];
    if (value != self) {
      (void) [buffer appendWithId:value];
    }
    else {
      (void) [buffer appendWithNSString:@"(this Map)"];
    }
  }
  (void) [buffer appendWithChar:'}'];
  return [buffer description];
}

+ (const J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { NULL, NULL, 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, NULL, 0x1, -1, 0, -1, -1, -1, -1 },
    { NULL, "LUkCoAmlcurranSocialCoreSparseArray;", 0x1, 1, -1, -1, 2, -1, -1 },
    { NULL, "LNSObject;", 0x1, 3, 0, -1, 4, -1, -1 },
    { NULL, "LNSObject;", 0x1, 3, 5, -1, 6, -1, -1 },
    { NULL, "V", 0x1, 7, 0, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 8, 0, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 9, 0, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 10, 11, -1, -1, -1, -1 },
    { NULL, "V", 0x2, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 12, 5, -1, 13, -1, -1 },
    { NULL, "I", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "I", 0x1, 14, 0, -1, -1, -1, -1 },
    { NULL, "LNSObject;", 0x1, 15, 0, -1, 4, -1, -1 },
    { NULL, "V", 0x1, 16, 5, -1, 13, -1, -1 },
    { NULL, "I", 0x1, 17, 0, -1, -1, -1, -1 },
    { NULL, "I", 0x1, 18, 19, -1, 20, -1, -1 },
    { NULL, "V", 0x1, -1, -1, -1, -1, -1, -1 },
    { NULL, "V", 0x1, 21, 5, -1, 13, -1, -1 },
    { NULL, "LNSString;", 0x1, 22, -1, -1, -1, -1, -1 },
  };
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-multiple-method-names"
  methods[0].selector = @selector(init);
  methods[1].selector = @selector(initWithInt:);
  methods[2].selector = @selector(java_clone);
  methods[3].selector = @selector(getWithInt:);
  methods[4].selector = @selector(getWithInt:withId:);
  methods[5].selector = @selector(delete__WithInt:);
  methods[6].selector = @selector(removeWithInt:);
  methods[7].selector = @selector(removeAtWithInt:);
  methods[8].selector = @selector(removeAtRangeWithInt:withInt:);
  methods[9].selector = @selector(gc);
  methods[10].selector = @selector(putWithInt:withId:);
  methods[11].selector = @selector(size);
  methods[12].selector = @selector(keyAtWithInt:);
  methods[13].selector = @selector(valueAtWithInt:);
  methods[14].selector = @selector(setValueAtWithInt:withId:);
  methods[15].selector = @selector(indexOfKeyWithInt:);
  methods[16].selector = @selector(indexOfValueWithId:);
  methods[17].selector = @selector(clear);
  methods[18].selector = @selector(appendWithInt:withId:);
  methods[19].selector = @selector(description);
  #pragma clang diagnostic pop
  static const J2ObjcFieldInfo fields[] = {
    { "DELETED", "LNSObject;", .constantValue.asLong = 0, 0x1a, -1, 23, -1, -1 },
    { "mGarbage_", "Z", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mKeys_", "[I", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mValues_", "[LNSObject;", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
    { "mSize_", "I", .constantValue.asLong = 0, 0x2, -1, -1, -1, -1 },
  };
  static const void *ptrTable[] = { "I", "clone", "()Luk/co/amlcurran/social/core/SparseArray<TE;>;", "get", "(I)TE;", "ILNSObject;", "(ITE;)TE;", "delete", "remove", "removeAt", "removeAtRange", "II", "put", "(ITE;)V", "keyAt", "valueAt", "setValueAt", "indexOfKey", "indexOfValue", "LNSObject;", "(TE;)I", "append", "toString", &UkCoAmlcurranSocialCoreSparseArray_DELETED, "<E:Ljava/lang/Object;>Ljava/lang/Object;" };
  static const J2ObjcClassInfo _UkCoAmlcurranSocialCoreSparseArray = { "SparseArray", "uk.co.amlcurran.social.core", ptrTable, methods, fields, 7, 0x1, 20, 5, -1, -1, -1, 24, -1 };
  return &_UkCoAmlcurranSocialCoreSparseArray;
}

+ (void)initialize {
  if (self == [UkCoAmlcurranSocialCoreSparseArray class]) {
    UkCoAmlcurranSocialCoreSparseArray_DELETED = new_NSObject_init();
    J2OBJC_SET_INITIALIZED(UkCoAmlcurranSocialCoreSparseArray)
  }
}

@end

void UkCoAmlcurranSocialCoreSparseArray_init(UkCoAmlcurranSocialCoreSparseArray *self) {
  UkCoAmlcurranSocialCoreSparseArray_initWithInt_(self, 10);
}

UkCoAmlcurranSocialCoreSparseArray *new_UkCoAmlcurranSocialCoreSparseArray_init() {
  J2OBJC_NEW_IMPL(UkCoAmlcurranSocialCoreSparseArray, init)
}

UkCoAmlcurranSocialCoreSparseArray *create_UkCoAmlcurranSocialCoreSparseArray_init() {
  J2OBJC_CREATE_IMPL(UkCoAmlcurranSocialCoreSparseArray, init)
}

void UkCoAmlcurranSocialCoreSparseArray_initWithInt_(UkCoAmlcurranSocialCoreSparseArray *self, jint initialCapacity) {
  NSObject_init(self);
  self->mGarbage_ = false;
  if (initialCapacity == 0) {
    self->mKeys_ = JreLoadStatic(UkCoAmlcurranSocialCoreContainerHelpers, EMPTY_INTS);
    self->mValues_ = JreLoadStatic(UkCoAmlcurranSocialCoreContainerHelpers, EMPTY_OBJECTS);
  }
  else {
    initialCapacity = UkCoAmlcurranSocialCoreContainerHelpers_idealIntArraySizeWithInt_(initialCapacity);
    self->mKeys_ = [IOSIntArray newArrayWithLength:initialCapacity];
    self->mValues_ = [IOSObjectArray newArrayWithLength:initialCapacity type:NSObject_class_()];
  }
  self->mSize_ = 0;
}

UkCoAmlcurranSocialCoreSparseArray *new_UkCoAmlcurranSocialCoreSparseArray_initWithInt_(jint initialCapacity) {
  J2OBJC_NEW_IMPL(UkCoAmlcurranSocialCoreSparseArray, initWithInt_, initialCapacity)
}

UkCoAmlcurranSocialCoreSparseArray *create_UkCoAmlcurranSocialCoreSparseArray_initWithInt_(jint initialCapacity) {
  J2OBJC_CREATE_IMPL(UkCoAmlcurranSocialCoreSparseArray, initWithInt_, initialCapacity)
}

void UkCoAmlcurranSocialCoreSparseArray_gc(UkCoAmlcurranSocialCoreSparseArray *self) {
  jint n = self->mSize_;
  jint o = 0;
  IOSIntArray *keys = self->mKeys_;
  IOSObjectArray *values = self->mValues_;
  for (jint i = 0; i < n; i++) {
    id val = IOSObjectArray_Get(nil_chk(values), i);
    if (val != UkCoAmlcurranSocialCoreSparseArray_DELETED) {
      if (i != o) {
        *IOSIntArray_GetRef(nil_chk(keys), o) = IOSIntArray_Get(keys, i);
        (void) IOSObjectArray_Set(values, o, val);
        (void) IOSObjectArray_Set(values, i, nil);
      }
      o++;
    }
  }
  self->mGarbage_ = false;
  self->mSize_ = o;
}

J2OBJC_CLASS_TYPE_LITERAL_SOURCE(UkCoAmlcurranSocialCoreSparseArray)
