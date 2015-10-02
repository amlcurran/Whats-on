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

static id UkCoAmlcurranSocialCoreSparseArray_DELETED_;
J2OBJC_STATIC_FIELD_GETTER(UkCoAmlcurranSocialCoreSparseArray, DELETED_, id)

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

- (UkCoAmlcurranSocialCoreSparseArray *)clone {
  UkCoAmlcurranSocialCoreSparseArray *clone = nil;
  @try {
    clone = (UkCoAmlcurranSocialCoreSparseArray *) check_class_cast([super clone], [UkCoAmlcurranSocialCoreSparseArray class]);
    ((UkCoAmlcurranSocialCoreSparseArray *) nil_chk(clone))->mKeys_ = [((IOSIntArray *) nil_chk(mKeys_)) clone];
    clone->mValues_ = [((IOSObjectArray *) nil_chk(mValues_)) clone];
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
  if (i < 0 || IOSObjectArray_Get(nil_chk(mValues_), i) == UkCoAmlcurranSocialCoreSparseArray_DELETED_) {
    return valueIfKeyNotFound;
  }
  else {
    return (id) IOSObjectArray_Get(mValues_, i);
  }
}

- (void)delete__WithInt:(jint)key {
  jint i = UkCoAmlcurranSocialCoreContainerHelpers_binarySearchWithIntArray_withInt_withInt_(mKeys_, mSize_, key);
  if (i >= 0) {
    if (IOSObjectArray_Get(nil_chk(mValues_), i) != UkCoAmlcurranSocialCoreSparseArray_DELETED_) {
      (void) IOSObjectArray_Set(mValues_, i, UkCoAmlcurranSocialCoreSparseArray_DELETED_);
      mGarbage_ = true;
    }
  }
}

- (void)removeWithInt:(jint)key {
  [self delete__WithInt:key];
}

- (void)removeAtWithInt:(jint)index {
  if (IOSObjectArray_Get(nil_chk(mValues_), index) != UkCoAmlcurranSocialCoreSparseArray_DELETED_) {
    (void) IOSObjectArray_Set(mValues_, index, UkCoAmlcurranSocialCoreSparseArray_DELETED_);
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
    if (i < mSize_ && IOSObjectArray_Get(nil_chk(mValues_), i) == UkCoAmlcurranSocialCoreSparseArray_DELETED_) {
      *IOSIntArray_GetRef(nil_chk(mKeys_), i) = key;
      (void) IOSObjectArray_Set(mValues_, i, value);
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
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mKeys_, 0, nkeys, 0, mKeys_->size_);
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mValues_, 0, nvalues, 0, ((IOSObjectArray *) nil_chk(mValues_))->size_);
      mKeys_ = nkeys;
      mValues_ = nvalues;
    }
    if (mSize_ - i != 0) {
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mKeys_, i, mKeys_, i + 1, mSize_ - i);
      JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mValues_, i, mValues_, i + 1, mSize_ - i);
    }
    *IOSIntArray_GetRef(mKeys_, i) = key;
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
  return (id) IOSObjectArray_Get(nil_chk(mValues_), index);
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
    JavaLangSystem_arraycopyWithId_withInt_withId_withInt_withInt_(mKeys_, 0, nkeys, 0, mKeys_->size_);
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

+ (void)initialize {
  if (self == [UkCoAmlcurranSocialCoreSparseArray class]) {
    UkCoAmlcurranSocialCoreSparseArray_DELETED_ = new_NSObject_init();
    J2OBJC_SET_INITIALIZED(UkCoAmlcurranSocialCoreSparseArray)
  }
}

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "init", "SparseArray", NULL, 0x1, NULL, NULL },
    { "initWithInt:", "SparseArray", NULL, 0x1, NULL, NULL },
    { "clone", NULL, "Luk.co.amlcurran.social.core.SparseArray;", 0x1, NULL, NULL },
    { "getWithInt:", "get", "TE;", 0x1, NULL, "(I)TE;" },
    { "getWithInt:withId:", "get", "TE;", 0x1, NULL, "(ITE;)TE;" },
    { "delete__WithInt:", "delete", "V", 0x1, NULL, NULL },
    { "removeWithInt:", "remove", "V", 0x1, NULL, NULL },
    { "removeAtWithInt:", "removeAt", "V", 0x1, NULL, NULL },
    { "removeAtRangeWithInt:withInt:", "removeAtRange", "V", 0x1, NULL, NULL },
    { "gc", NULL, "V", 0x2, NULL, NULL },
    { "putWithInt:withId:", "put", "V", 0x1, NULL, "(ITE;)V" },
    { "size", NULL, "I", 0x1, NULL, NULL },
    { "keyAtWithInt:", "keyAt", "I", 0x1, NULL, NULL },
    { "valueAtWithInt:", "valueAt", "TE;", 0x1, NULL, "(I)TE;" },
    { "setValueAtWithInt:withId:", "setValueAt", "V", 0x1, NULL, "(ITE;)V" },
    { "indexOfKeyWithInt:", "indexOfKey", "I", 0x1, NULL, NULL },
    { "indexOfValueWithId:", "indexOfValue", "I", 0x1, NULL, "(TE;)I" },
    { "clear", NULL, "V", 0x1, NULL, NULL },
    { "appendWithInt:withId:", "append", "V", 0x1, NULL, "(ITE;)V" },
    { "description", "toString", "Ljava.lang.String;", 0x1, NULL, NULL },
  };
  static const J2ObjcFieldInfo fields[] = {
    { "DELETED_", NULL, 0x1a, "Ljava.lang.Object;", &UkCoAmlcurranSocialCoreSparseArray_DELETED_, NULL, .constantValue.asLong = 0 },
    { "mGarbage_", NULL, 0x2, "Z", NULL, NULL, .constantValue.asLong = 0 },
    { "mKeys_", NULL, 0x2, "[I", NULL, NULL, .constantValue.asLong = 0 },
    { "mValues_", NULL, 0x2, "[Ljava.lang.Object;", NULL, NULL, .constantValue.asLong = 0 },
    { "mSize_", NULL, 0x2, "I", NULL, NULL, .constantValue.asLong = 0 },
  };
  static const J2ObjcClassInfo _UkCoAmlcurranSocialCoreSparseArray = { 2, "SparseArray", "uk.co.amlcurran.social.core", NULL, 0x1, 20, methods, 5, fields, 0, NULL, 0, NULL, NULL, "<E:Ljava/lang/Object;>Ljava/lang/Object;" };
  return &_UkCoAmlcurranSocialCoreSparseArray;
}

@end

void UkCoAmlcurranSocialCoreSparseArray_init(UkCoAmlcurranSocialCoreSparseArray *self) {
  (void) UkCoAmlcurranSocialCoreSparseArray_initWithInt_(self, 10);
}

UkCoAmlcurranSocialCoreSparseArray *new_UkCoAmlcurranSocialCoreSparseArray_init() {
  UkCoAmlcurranSocialCoreSparseArray *self = [UkCoAmlcurranSocialCoreSparseArray alloc];
  UkCoAmlcurranSocialCoreSparseArray_init(self);
  return self;
}

void UkCoAmlcurranSocialCoreSparseArray_initWithInt_(UkCoAmlcurranSocialCoreSparseArray *self, jint initialCapacity) {
  (void) NSObject_init(self);
  self->mGarbage_ = false;
  if (initialCapacity == 0) {
    self->mKeys_ = JreLoadStatic(UkCoAmlcurranSocialCoreContainerHelpers, EMPTY_INTS_);
    self->mValues_ = JreLoadStatic(UkCoAmlcurranSocialCoreContainerHelpers, EMPTY_OBJECTS_);
  }
  else {
    initialCapacity = UkCoAmlcurranSocialCoreContainerHelpers_idealIntArraySizeWithInt_(initialCapacity);
    self->mKeys_ = [IOSIntArray newArrayWithLength:initialCapacity];
    self->mValues_ = [IOSObjectArray newArrayWithLength:initialCapacity type:NSObject_class_()];
  }
  self->mSize_ = 0;
}

UkCoAmlcurranSocialCoreSparseArray *new_UkCoAmlcurranSocialCoreSparseArray_initWithInt_(jint initialCapacity) {
  UkCoAmlcurranSocialCoreSparseArray *self = [UkCoAmlcurranSocialCoreSparseArray alloc];
  UkCoAmlcurranSocialCoreSparseArray_initWithInt_(self, initialCapacity);
  return self;
}

void UkCoAmlcurranSocialCoreSparseArray_gc(UkCoAmlcurranSocialCoreSparseArray *self) {
  jint n = self->mSize_;
  jint o = 0;
  IOSIntArray *keys = self->mKeys_;
  IOSObjectArray *values = self->mValues_;
  for (jint i = 0; i < n; i++) {
    id val = IOSObjectArray_Get(nil_chk(values), i);
    if (val != UkCoAmlcurranSocialCoreSparseArray_DELETED_) {
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
