class ComparableObject(object):
    """ A superclass to use to automatically create comparableness and nice repr.  """
    def __repr__(self):
        return "{}({})".format(type(self).__name__,
                ", ".join("{}={}".format(attr, repr(getattr(self, attr)))
                                         for attr in self.__dict__))

    def __eq__(self, other):
        if not isinstance(other, type(self)):
            return False

        for attr in self.__dict__:
            if getattr(self, attr) != getattr(other, attr):
                return False
        return True

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return hash(tuple(self.__dict__.items()))

    @classmethod
    def _from_obj_dict(cls, obj_dict):
        return cls(**obj_dict)
